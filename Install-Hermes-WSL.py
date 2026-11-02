#!/usr/bin/env python3
"""Install the 16-skill pack into Hermes running inside WSL/Linux.

This script installs seven upstream skills through `hermes skills install`
(the Hermes Skills Hub scanner), and copies the nine original/local skills.
It does not install anything into OpenCode.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
import urllib.error
import urllib.request
import zipfile
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

PACKAGE_ROOT = Path(__file__).resolve().parent
MANIFEST = json.loads((PACKAGE_ROOT / "manifest.json").read_text(encoding="utf-8"))
ALL_NAMES = list(MANIFEST["all_skill_ids"])
LOCAL_NAMES = list(MANIFEST["local_skill_ids"])
UPSTREAM = list(MANIFEST["upstream_sources"])
HERMES_HOME = Path(os.environ.get("HERMES_HOME", str(Path.home() / ".hermes"))).expanduser()
HERMES_ROOT = HERMES_HOME / "skills"


def request_bytes(url: str, timeout: int = 90) -> bytes:
    req = urllib.request.Request(
        url,
        headers={"User-Agent": "Hermes-OpenCode-MasterSkills-Installer/2.0"},
    )
    with urllib.request.urlopen(req, timeout=timeout) as response:
        return response.read()


def resolve_ref(repository: str, ref: str) -> str:
    url = f"https://api.github.com/repos/{repository}/commits/{ref}"
    try:
        payload = json.loads(request_bytes(url, timeout=30).decode("utf-8"))
        sha = payload.get("sha")
        return sha if isinstance(sha, str) and sha else ref
    except Exception as exc:
        print(f"WARNING: Could not resolve {repository}@{ref}: {exc}; using ref as supplied.")
        return ref


def safe_extract(archive_bytes: bytes, destination: Path) -> Path:
    destination.mkdir(parents=True, exist_ok=True)
    archive_path = destination / "source.zip"
    archive_path.write_bytes(archive_bytes)
    with zipfile.ZipFile(archive_path) as archive:
        root_resolved = destination.resolve()
        for member in archive.infolist():
            target = (destination / member.filename).resolve()
            if target != root_resolved and root_resolved not in target.parents:
                raise RuntimeError(f"Unsafe ZIP path rejected: {member.filename}")
        archive.extractall(destination)
    roots = [p for p in destination.iterdir() if p.is_dir()]
    if not roots:
        raise RuntimeError("Downloaded archive did not contain a repository directory.")
    return roots[0]


def verify_package_hashes() -> None:
    checksum_file = PACKAGE_ROOT / "SHA256SUMS.txt"
    if not checksum_file.exists():
        raise RuntimeError("SHA256SUMS.txt is missing from the package.")
    for line in checksum_file.read_text(encoding="utf-8").splitlines():
        if not line.strip():
            continue
        match = re.fullmatch(r"([a-fA-F0-9]{64})\s{2}(.+)", line)
        if not match:
            raise RuntimeError(f"Invalid checksum manifest line: {line}")
        expected, relative = match.groups()
        target = PACKAGE_ROOT / relative
        if not target.is_file():
            raise RuntimeError(f"Checksum target missing: {relative}")
        actual = hashlib.sha256(target.read_bytes()).hexdigest()
        if actual.lower() != expected.lower():
            raise RuntimeError(f"SHA-256 mismatch: {relative}")
    print("Package SHA-256 manifest: OK")


def parse_skill_name(skill_file: Path) -> tuple[str | None, str | None, str]:
    raw = skill_file.read_text(encoding="utf-8-sig")
    match = re.match(r"\A---\s*\n(.*?)\n---\s*\n", raw, re.S)
    if not match:
        return None, None, raw
    frontmatter = match.group(1)
    name_match = re.search(r"(?m)^name:\s*['\"]?([^'\"\r\n]+)['\"]?\s*$", frontmatter)
    description_match = re.search(r"(?m)^description:\s*(\S.*)$", frontmatter)
    name = name_match.group(1).strip() if name_match else None
    description = description_match.group(1).strip().strip("\"'") if description_match else None
    return name, description, raw


def find_skill_dirs(root: Path, skill_name: str) -> list[Path]:
    if not root.exists():
        return []
    found: list[Path] = []
    for skill_file in root.rglob("SKILL.md"):
        if ".hub" in skill_file.parts:
            continue
        name, _, _ = parse_skill_name(skill_file)
        if name == skill_name:
            found.append(skill_file.parent)
    return found


def validate_tree(root: Path, expected: list[str]) -> None:
    errors: list[str] = []
    for name in expected:
        if not re.fullmatch(r"[a-z0-9]+(?:-[a-z0-9]+)*", name):
            errors.append(f"Invalid skill ID: {name}")
            continue
        matches = find_skill_dirs(root, name)
        if len(matches) != 1:
            errors.append(f"{name}: expected one SKILL.md, found {len(matches)}")
            continue
        skill_dir = matches[0]
        if skill_dir.name != name:
            errors.append(f"{name}: containing directory is named {skill_dir.name}")
            continue
        actual_name, description, raw = parse_skill_name(skill_dir / "SKILL.md")
        if actual_name != name:
            errors.append(f"{name}: frontmatter name mismatch ({actual_name})")
        if not description or not (1 <= len(description) <= 60):
            errors.append(f"{name}: description missing or outside 1-60 chars")
        for match in re.findall(r"`((?:references|templates|examples|scripts)/[^`]+)`", raw):
            rel = match.strip()
            if "*" in rel or any(ch.isspace() for ch in rel):
                continue
            rel = re.split(r"[:#]", rel, maxsplit=1)[0]
            candidate = skill_dir / rel
            if not candidate.exists():
                errors.append(f"{name}: missing referenced file {rel}")
    if errors:
        raise RuntimeError("Validation failed:\n- " + "\n- ".join(errors))
    print(f"VALID: {len(expected)} skill(s) under {root}")


def add_compatibility(skill_name: str, skill_dir: Path) -> None:
    skill_file = skill_dir / "SKILL.md"
    content = skill_file.read_text(encoding="utf-8-sig")
    short_description = MANIFEST.get("compact_descriptions", {}).get(skill_name)
    if short_description:
        content, _ = re.subn(
            r"(?m)^description:\s*.*$",
            f"description: {short_description}",
            content,
            count=1,
        )

    if skill_name == "systematic-debugging":
        content = content.replace(
            "Use the `superpowers:test-driven-development` skill for writing proper failing tests",
            "Use an available host-native test workflow to create a minimal failing reproduction; if a separate TDD skill is installed, it may be used.",
        )
        content = content.replace(
            "superpowers:verification-before-completion",
            "verification-before-completion",
        )
    elif skill_name == "requesting-code-review":
        content = content.replace(
            "Dispatch a code reviewer subagent to catch issues before they cascade.",
            "When the host supports an independent subagent, dispatch a code reviewer to catch issues before they cascade. If not, perform a scoped in-session review using the bundled template and disclose that it was not independent.",
        )
        content = content.replace(
            "Dispatch a `general-purpose` subagent, filling the template at `code-reviewer.md`",
            "If a suitable subagent is available, dispatch it using the template at `code-reviewer.md`. Otherwise use that template for a focused in-session review.",
        )
    elif skill_name == "writing-plans":
        content = content.replace(
            "superpowers:using-git-worktrees",
            "using-git-worktrees (if installed)",
        )
        content = content.replace(
            "REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task.",
            "OPTIONAL EXECUTION INTEGRATION: Use subagent-driven-development or executing-plans if installed; otherwise follow the host native sequential workflow after the user approves the plan.",
        )
        content = content.replace(
            "REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development",
            "OPTIONAL EXECUTION INTEGRATION: Use subagent-driven-development if installed; otherwise use the host native workflow after approval.",
        )
        content = content.replace(
            "REQUIRED SUB-SKILL: Use superpowers:executing-plans",
            "OPTIONAL EXECUTION INTEGRATION: Use executing-plans if installed; otherwise use the host native sequential workflow after approval.",
        )
    elif skill_name == "context-optimization":
        content += """

## Selected-bundle compatibility note

This bundle includes only `context-optimization`, `context-compression`, and `filesystem-context` from the larger context-engineering collection. Other sibling skills named in this upstream document are not installed here. If an adjacent sibling is unavailable, use host-native reasoning or state the limitation; do not invoke a skill that is not present.

Runtime caveat: do not invent context utilization, token counts, cache-hit rates, or quality measurements. Use compaction, masking, KV-cache, and partitioning only when the host actually exposes the capability. Treat numeric thresholds and performance targets in this document as heuristics or targets to evaluate, not guarantees. Never discard active errors, user constraints, exact values, or unresolved evidence merely to reduce context.
"""
    elif skill_name == "context-compression":
        content += """

## Selected-bundle compatibility note

This bundle includes only `context-optimization`, `context-compression`, and `filesystem-context` from the larger context-engineering collection. Other sibling skills referenced by the upstream document are not installed here. If a referenced skill is unavailable, use the host-native workflow and disclose that no separate skill was loaded.

Preserve exact user constraints, decisions, filenames, paths, versions, measurements, error messages, verification evidence, unresolved risks, and next actions. Do not compress away active debugging evidence or replace unknown facts with assumptions.
"""
    elif skill_name == "filesystem-context":
        content += """

## Selected-bundle compatibility note

This bundle includes only `context-optimization`, `context-compression`, and `filesystem-context` from the larger context-engineering collection. Other sibling skills referenced by the upstream document are not installed here. If a referenced skill is unavailable, use host-native file operations and disclose the limitation.

Use project-approved paths, preserve source artifacts, avoid storing credentials or sensitive data in scratch files, and retrieve only the relevant file ranges. File offloading is not permission to modify, delete, or publish project data.
"""

    note = """

## Master bundle portability and approval note

This is a selected standalone-skill installation, not the complete upstream plugin or skill collection. Check whether optional referenced skills and tools are actually available. If not, use a host-native fallback and disclose the limitation. Recommendations to edit, commit, publish, release manufacturing data, or perform physical actions do not grant permission; user approval and domain-specific safety boundaries take precedence.
"""
    if "Master bundle portability and approval note" not in content:
        content += note
    skill_file.write_text(content, encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--force", action="store_true", help="Back up and replace existing local/original skills only.")
    args = parser.parse_args()

    if shutil.which("hermes") is None:
        print("ERROR: hermes CLI not found in this WSL/Linux environment.", file=sys.stderr)
        return 2

    if len(ALL_NAMES) != 16 or len(set(ALL_NAMES)) != 16:
        print("ERROR: manifest must contain 16 unique skill IDs.", file=sys.stderr)
        return 2

    verify_package_hashes()
    validate_tree(PACKAGE_ROOT / "skills", LOCAL_NAMES)
    legacy_shared = Path.home() / ".agents" / "skills"
    if legacy_shared.exists():
        legacy_names = [name for name in ALL_NAMES if find_skill_dirs(legacy_shared, name)]
        if legacy_names:
            print("WARNING: legacy shared skill copies exist under ~/.agents/skills and are left untouched: " + ", ".join(legacy_names))
    for legacy_root in [legacy_shared, HERMES_ROOT]:
        for restricted_name in ("docx", "pdf", "xlsx", "pptx"):
            if find_skill_dirs(legacy_root, restricted_name):
                print(
                    f"WARNING: possible legacy Anthropic document skill '{restricted_name}' found under {legacy_root}; verify its origin and license before retaining or using it.",
                    file=sys.stderr,
                )
    existing_upstream = [name for name in [n for source in UPSTREAM for n in source["skills"]] if find_skill_dirs(HERMES_ROOT, name)]
    if existing_upstream:
        print(
            "ERROR: existing Hermes upstream skill folders detected: "
            + ", ".join(existing_upstream)
            + ". Update Hub-managed copies with `hermes skills update`, or inspect/archive legacy manual copies before retrying.",
            file=sys.stderr,
        )
        return 3

    existing_local = [name for name in LOCAL_NAMES if find_skill_dirs(HERMES_ROOT, name)]
    if existing_local and not args.force:
        print(
            "ERROR: existing local skill folders detected: "
            + ", ".join(existing_local)
            + ". Re-run with --force to back them up and replace them.",
            file=sys.stderr,
        )
        return 3

    timestamp = datetime.now().strftime("%Y%m%d-%H%M%S-%f")
    backup_root = Path.home() / ".skill-install-backups" / f"master-skills-wsl-{timestamp}"
    copied_local: list[Path] = []
    backups: list[tuple[Path, Path]] = []
    hub_installed: list[str] = []
    source_log: list[dict[str, Any]] = []

    try:
        with tempfile.TemporaryDirectory(prefix="master-skills-wsl-") as temp_name:
            temp_root = Path(temp_name)
            stage_root = temp_root / "staged-skills"
            stage_root.mkdir(parents=True)

            # Stage original/local skills.
            for name in LOCAL_NAMES:
                shutil.copytree(PACKAGE_ROOT / "skills" / name, stage_root / name)

            # Download, pin, license, and stage upstream skills.
            for source in UPSTREAM:
                repo = source["repository"]
                requested_ref = source["ref"]
                resolved_ref = resolve_ref(repo, requested_ref)
                archive_bytes = request_bytes(f"https://codeload.github.com/{repo}/zip/{resolved_ref}")
                archive_hash = hashlib.sha256(archive_bytes).hexdigest()
                repo_root = safe_extract(archive_bytes, temp_root / (repo.split("/")[-1] + "-source"))
                license_path = repo_root / "LICENSE"
                if not license_path.exists():
                    license_path = repo_root / "LICENSE.txt"
                if not license_path.exists():
                    raise RuntimeError(f"Upstream license file missing for {repo}")

                for name in source["skills"]:
                    source_skill = repo_root / "skills" / name
                    if not (source_skill / "SKILL.md").exists():
                        raise RuntimeError(f"Upstream skill folder missing: {repo}/skills/{name}")
                    target_skill = stage_root / name
                    shutil.copytree(source_skill, target_skill)
                    shutil.copy2(license_path, target_skill / "UPSTREAM-LICENSE.txt")
                    raw_url = f"https://raw.githubusercontent.com/{repo}/{resolved_ref}/skills/{name}/SKILL.md"
                    source_info = (
                        f"Repository: {repo}\nRequested ref: {requested_ref}\nResolved ref: {resolved_ref}\n"
                        f"Archive SHA-256: {archive_hash}\nRetrieved UTC: {datetime.now(timezone.utc).isoformat()}\n"
                    )
                    (target_skill / "UPSTREAM-SOURCE.txt").write_text(source_info, encoding="utf-8")
                    add_compatibility(name, target_skill)
                    source_log.append({
                        "skill": name,
                        "repository": repo,
                        "requested_ref": requested_ref,
                        "resolved_ref": resolved_ref,
                        "archive_sha256": archive_hash,
                        "hermes_raw_url": raw_url,
                    })

            validate_tree(stage_root, ALL_NAMES)

            # Copy the nine local/original skills into Hermes.
            HERMES_ROOT.mkdir(parents=True, exist_ok=True)
            for name in LOCAL_NAMES:
                dest = HERMES_ROOT / name
                if dest.exists():
                    backup = backup_root / name
                    backup.parent.mkdir(parents=True, exist_ok=True)
                    shutil.move(str(dest), str(backup))
                    backups.append((dest, backup))
                copied_local.append(dest)
                shutil.copytree(stage_root / name, dest)

            # Install seven upstream skills through Hermes' security scanner.
            for record in source_log:
                name = record["skill"]
                print(f"\nHermes security-scanned install: {name}")
                result = subprocess.run(["hermes", "skills", "install", record["hermes_raw_url"]], check=False)
                if result.returncode != 0:
                    raise RuntimeError(
                        f"Hermes install failed or was declined for {name}. Earlier Hub installs may remain; inspect `hermes skills list`."
                    )
                matches = find_skill_dirs(HERMES_ROOT, name)
                if len(matches) != 1:
                    raise RuntimeError(f"Expected one active Hermes installation for {name}, found {len(matches)}")
                installed_dir = matches[0]
                hub_installed.append(name)
                shutil.copy2(stage_root / name / "UPSTREAM-LICENSE.txt", installed_dir / "UPSTREAM-LICENSE.txt")
                shutil.copy2(stage_root / name / "UPSTREAM-SOURCE.txt", installed_dir / "UPSTREAM-SOURCE.txt")
                add_compatibility(name, installed_dir)
                for support_file in (stage_root / name).glob("*.md"):
                    if support_file.name != "SKILL.md":
                        shutil.copy2(support_file, installed_dir / support_file.name)

            audit = subprocess.run(["hermes", "skills", "audit"], check=False)
            if audit.returncode != 0:
                print("WARNING: `hermes skills audit` returned a non-zero status. Review Hermes audit/quarantine output before use.")

            validate_tree(HERMES_ROOT, ALL_NAMES)
            subprocess.run(["hermes", "skills", "list"], check=False)

            log_dir = Path.home() / ".skill-install-logs"
            log_dir.mkdir(parents=True, exist_ok=True)
            log_path = log_dir / f"master-skills-{timestamp}.json"
            log_path.write_text(json.dumps(source_log, indent=2), encoding="utf-8")
            print(f"\nHermes installation completed. Source log: {log_path}")
            print("Restart Hermes to refresh the skill index.")
            return 0

    except Exception:
        for dest in reversed(copied_local):
            if dest.exists():
                shutil.rmtree(dest, ignore_errors=True)
        for original, backup in reversed(backups):
            if backup.exists():
                original.parent.mkdir(parents=True, exist_ok=True)
                if original.exists():
                    shutil.rmtree(original, ignore_errors=True)
                shutil.move(str(backup), str(original))
        if hub_installed:
            print("WARNING: Hermes Hub-installed skills are not automatically uninstalled during rollback: " + ", ".join(hub_installed), file=sys.stderr)
            print("Inspect `hermes skills list` and manage those skills through Hermes.", file=sys.stderr)
        raise


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        print("If local custom skills were copied before failure, review ~/.hermes/skills and the backup directory.", file=sys.stderr)
        raise
