# Master Skills Integration Audit Report

**Package:** Master Skills Pack V2.1.1  
**Audit date:** 2026-11-02  
**Targets:** Hermes Agent + OpenCode on Windows and WSL  
**Declared capabilities:** 16

## Executive result

The 16-skill set can be integrated as a single managed installation, with three important adjustments:

1. Use each platform's native global skill directory to avoid duplicate shared/native copies.
2. Add explicit ownership boundaries and fallback behavior where selected skills refer to optional Superpowers skills or subagent capabilities that are not included.
3. Replace the four Anthropic document skill folders with independently authored document-workflow skills because the upstream per-skill license restricts retaining/copying those materials outside Anthropic services.

## 1. Inventory result

| Group | Count | Result |
|---|---:|---|
| Selected Superpowers skills | 4 | Retained as upstream skills, with local portability notes |
| Selected context-engineering skills | 3 | Retained as upstream skills |
| Original document workflow skills | 4 | Authored independently for DOCX/PDF/XLSX/PPTX operations |
| Custom domain skills | 5 | Full V2 folders consolidated |
| **Total** | **16** | **Unique skill IDs** |

All 16 IDs are unique in `manifest.json`. Nine skills are packaged locally; seven are downloaded from the two MIT-licensed upstream repositories at installation time.

## 2. Findings and resolutions

| ID | Severity | Finding | Resolution |
|---|---|---|---|
| LIC-001 | Critical | Anthropic's `docx`, `pdf`, `xlsx`, `pptx` folders have per-skill restrictions on retaining copies outside Anthropic services and on reproduction/derivative works/redistribution. | Excluded the upstream folders. Added four independently authored replacements with distinct IDs and documented the substitution. |
| PATH-001 | High | Earlier installers used different locations: shared `.agents`, Hermes-native `.hermes`, and OpenCode-native `.config/opencode`. This can create duplicate or shadowed IDs. | Unified installer uses Hermes and OpenCode native global paths only. It does not change config files or add a third shared copy. |
| DEP-001 | High | `systematic-debugging` references `test-driven-development`, which is not among the selected skills. | Installer patches the local copy to use a host-native failing-test workflow when the optional TDD skill is absent. |
| DEP-002 | High | `writing-plans` references brainstorming, worktree, subagent-driven-development, and executing-plans skills not included in the selected 16. | Installer changes those integrations to optional and supplies a host-native sequential fallback. |
| DEP-003 | Medium | `requesting-code-review` expects a `general-purpose` subagent, which may not exist under that name or may be unavailable. | Installer adds an in-session review fallback and requires disclosure when review is not independent. |
| ROUTE-001 | Medium | Document file skills and domain-review skills can overlap (e.g., academic DOCX, PRD DOCX, creative PPTX). | Added a routing policy: domain skill owns content correctness; file-format skill owns file operations and rendering. |
| ROUTE-002 | Medium | Embedded firmware and PCB review overlap at MCU pins and board interfaces. | `embedded-firmware-reviewer` owns firmware/runtime and interface behavior; `kicad-pcb-reviewer` owns schematic/PCB/footprint/stackup/fabrication. Invoke both only when the problem crosses the boundary. |
| ROUTE-003 | Medium | The three context skills overlap around context size and file storage. | Added clear boundaries: optimization (budget/retrieval/masking), compression (handoff summary), filesystem (durable file offload). |
| META-001 | Medium | Several custom skill descriptions exceeded Hermes' compact authoring guidance. | All 16 descriptions are mapped to 60 characters or fewer; local files are normalized in the package and installers normalize upstream copies. The validator enforces the same limit, which is within OpenCode's 1-1024 character rule. |
| DEP-004 | Medium | Document skills may need optional Python libraries, OCR/renderers, or Office applications. | Added dependency notes; installer copies skills only and does not install or execute dependencies. |
| SEC-001 | High | Directly copying third-party skills into Hermes would bypass its current Skills Hub scanner and provenance flow. | The seven upstream skills are installed through `hermes skills install` using pinned raw URLs, then re-audited with `hermes skills audit`. The nine original/local skills are copied locally. |
| SEC-002 | Medium | OpenCode's native skill directory does not use Hermes' Skills Hub scanner. | OpenCode receives the same pinned upstream archive copies after structural validation; source refs and archive hashes are recorded. The installer does not execute downloaded scripts, and users should review upstream files before activation. |
| UPDATE-001 | Medium | Local portability patches change the upstream SKILL.md hash after Hermes Hub installation. | Documented that Hermes may mark patched copies as user-modified and skip ordinary updates; refresh by backing up, uninstalling through Hermes, and reinstalling with this package. |
| VERIFY-001 | Medium | Static file validation cannot prove that Hermes/OpenCode discover or correctly route the skills. | Added Windows runtime smoke-test plan; not claimed as complete until run on the user's machine. |

## 3. Skill ownership boundaries

The authoritative matrix is `skill-routing-policy.md`. Key rules:

- `verification-before-completion` is the universal completion evidence gate.
- `systematic-debugging` is the investigation method; domain reviewers supply the engineering-specific analysis.
- `requesting-code-review` is for code changes, not PCB design, manuscript, or creative review.
- `writing-plans` produces implementation plans; `technical-prd-architect` owns product requirements and PRD quality.
- File-format workflows do not silently rewrite scientific, product, or brand content.
- Domain-specific approval and physical safety boundaries override generic execution suggestions.

## 4. Context and token-efficiency assessment

The 16 skills are not intended to be loaded in full for every turn. Both target platforms support on-demand skill loading. Keep descriptions precise and supporting references on demand. Avoid activating all three context skills together:
- `context-optimization`: choose and budget context.
- `context-compression`: summarize and hand off durable state.
- `filesystem-context`: store and retrieve bulky/durable artifacts.

The separate `quality-first-efficiency` pack is not counted in the 16. It remains an optional companion and should not be installed as a duplicate substitute for the three context skills without reviewing its overlap.

## 5. Static validation performed in package construction

The package builder checked:
- 16 manifest IDs and uniqueness.
- YAML frontmatter parsing for all nine local skills.
- Folder name and frontmatter `name` equality for local skills.
- Non-empty descriptions of 60 characters or fewer and OpenCode-compatible slug format for local skills.
- All explicit local `references/`, `templates/`, `examples/`, and `scripts/` paths found in local SKILL.md files.
- Local skill SKILL.md files are below 500 lines.
- Installer, validator, routing policy, license notes, and smoke tests are present.

The WSL helper passed Python syntax compilation. The PowerShell installer and validator are included but could not be executed in this package-building environment because Windows PowerShell/PowerShell Core was not available. Their runtime behavior remains unverified. Hermes CLI scanning and the interactive install prompts also require a real Hermes installation.

## 6. Required Windows runtime tests

1. Run package validation with `-ValidateOnly`.
2. Install on Hermes and OpenCode.
3. Run `hermes skills list`.
4. Restart OpenCode and invoke skills explicitly with `@skill-id`.
5. Confirm all 16 are discoverable in both.
6. Run the activation smoke tests in `activation-smoke-tests.csv`.
7. Confirm no old `.agents/skills` duplicates or local skill overrides are shadowing the new native copies.
8. Verify file-format dependencies separately before expecting document rendering or OCR.

## 7. Release assessment

**Package status:** Ready for controlled Windows or WSL installation testing.  
**Runtime status:** Not yet verified on the user's Windows installation.  
**License status:** The four restricted Anthropic document folders are not included.  
**Safety status:** Existing skill project files are not modified by the installer; pre-existing skill folders are backed up only when `-Force` is explicitly supplied.


## PATH-002 — Native Windows Hermes home

The previous installer path assumed `$HOME\.hermes` for native Windows. Current Hermes Windows-native documentation places default user data under `%LOCALAPPDATA%\hermes`. V2.1.1 now resolves `%HERMES_HOME%` when set, otherwise `%LOCALAPPDATA%\hermes` on native Windows and `~/.hermes` on WSL/Linux. OpenCode remains at `~/.config/opencode/skills`.
