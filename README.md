# Master Skills Pack V2.1.1 — Hermes Agent + OpenCode (Windows / WSL)

A consolidated, audited installation package for 16 skill capabilities.

## 1. Inventory

### Seven upstream skills (MIT-licensed repositories)
| Group | Skill IDs | Source |
|---|---|---|
| Debugging & development | `systematic-debugging`, `requesting-code-review`, `verification-before-completion`, `writing-plans` | [obra/superpowers](https://github.com/obra/superpowers) |
| Context engineering | `context-optimization`, `context-compression`, `filesystem-context` | [Agent-Skills-for-Context-Engineering](https://github.com/muratcankoylan/Agent-Skills-for-Context-Engineering) |

### Four original document-workflow skills
| Original requested capability | Included skill |
|---|---|
| DOCX | `word-document-workflow` |
| PDF | `pdf-document-workflow` |
| XLSX | `spreadsheet-workflow` |
| PPTX | `presentation-workflow` |

These four are independently authored interoperability skills. They are **not** Anthropic's official document skills.

### Five custom domain skills
- `embedded-firmware-reviewer`
- `kicad-pcb-reviewer`
- `academic-manuscript-reviewer`
- `technical-prd-architect`
- `creative-content-reviewer`

**Total: 16 unique skill IDs.** Seven are downloaded from MIT-licensed upstream repositories; nine are packaged locally. All skill descriptions are compact (≤60 characters) to reduce index overhead and follow Hermes authoring guidance.

## 2. Important license adjustment

The `docx`, `pdf`, `xlsx`, and `pptx` folders in `anthropics/skills` have per-skill license terms that restrict copying, retaining copies outside Anthropic services, derivative works, and redistribution. This package deliberately does not copy those folders. Original alternatives with the same file-operation goals are included instead. See `docs/source-and-license-notes.md`.

The two upstream sources actually downloaded by the installer are MIT-licensed. Their root `LICENSE` files are copied into each selected upstream skill directory as `UPSTREAM-LICENSE.txt`.

## 3. Package layout

```text
master-skills-hermes-opencode-v2/
├── Install-Skills.ps1
├── Install-Hermes-WSL.py
├── Validate-Skills.ps1
├── manifest.json
├── SHA256SUMS.txt
├── README.md
├── licenses/
│   └── README.md
├── docs/
│   ├── integration-audit-report.md
│   ├── skill-routing-policy.md
│   ├── superpowers-portability-patch.md
│   ├── context-engineering-portability-patch.md
│   ├── source-and-license-notes.md
│   ├── dependencies-and-platform-notes.md
│   ├── validation-plan.md
│   ├── build-validation-summary.md
│   ├── activation-smoke-tests.csv
│   └── legacy-migration.md
└── skills/
    ├── word-document-workflow/
    ├── pdf-document-workflow/
    ├── spreadsheet-workflow/
    ├── presentation-workflow/
    ├── embedded-firmware-reviewer/
    ├── kicad-pcb-reviewer/
    ├── academic-manuscript-reviewer/
    ├── technical-prd-architect/
    └── creative-content-reviewer/
```

The seven upstream skills are downloaded at install time, resolved to commit SHAs when GitHub API access is available, and staged alongside the nine local/original skills.

## 4. Preflight: identify the Hermes environment

Open PowerShell and run:

```powershell
Get-Command hermes -All | Select-Object Source,CommandType
hermes --version
$env:HERMES_HOME
$env:LOCALAPPDATA
```

If the Hermes executable resolves under `%LOCALAPPDATA%\\hermes\\bin`, use the native Windows instructions below. If you normally run Hermes from an Ubuntu/WSL terminal, use the WSL instructions. The installer now resolves native Windows, WSL/Linux, and custom `HERMES_HOME` paths separately.

## 5. Install when Hermes and OpenCode both run natively on Windows

Requirements:
- Windows 10/11
- Windows PowerShell 5.1 or PowerShell 7
- `hermes` CLI available in the PowerShell PATH
- Internet access to GitHub
- Hermes Agent and OpenCode installed separately

Extract the ZIP, open PowerShell in the extracted folder, then validate the nine locally packaged skills and package SHA-256 manifest:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\Install-Skills.ps1 -ValidateOnly
```

Install all 16 skills:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\Install-Skills.ps1
```

The installer uses:
- OpenCode's native global skill directory for all 16.
- Hermes' official `hermes skills install` command for the seven upstream skills, using pinned raw GitHub URLs so the Hermes security scanner and provenance flow run.
- Direct validated copies into Hermes for the nine original/local skills.

Hermes may ask you to approve each upstream installation. Review its security result before accepting. The installer then applies a small local compatibility patch to the selected upstream `SKILL.md` files and runs `hermes skills audit`. Hermes may consequently mark those files as user-modified and skip them during ordinary upstream updates. To refresh one later, back it up, uninstall that Hub skill with `hermes skills uninstall <skill-id>`, then rerun this package installer so the pinned source is rescanned and the compatibility patch is reapplied.

### Existing installations

If OpenCode or local-Hermes destinations already contain the same skill IDs, the installer stops before modifying destinations. `-Force` backs up and replaces those copy-based destinations:

```powershell
.\Install-Skills.ps1 -Force
```

Existing upstream skills in Hermes are intentionally **not** overwritten by `-Force`; update Hub-managed copies through Hermes, or inspect/archive legacy manual copies first. This avoids bypassing Hermes' registry and scanner.

### Install only one platform

OpenCode only:

```powershell
.\Install-Skills.ps1 -SkipHermes
```

Hermes only (native Windows CLI):

```powershell
.\Install-Skills.ps1 -SkipOpenCode
```

### Validate installed skills

```powershell
.\Install-Skills.ps1 -ValidateInstalled
```

The validator recursively checks skill folders, so it can handle Hermes category directories as well as flat OpenCode directories.

## 6. If Hermes runs inside WSL

The Windows PowerShell installer cannot invoke the Hermes CLI inside a WSL distribution automatically.

1. Install the OpenCode copies from Windows PowerShell:

```powershell
.\Install-Skills.ps1 -SkipHermes
```

2. Open your WSL terminal and navigate to the extracted package through `/mnt/c/...`.
3. Run the WSL helper:

```bash
python3 ./Install-Hermes-WSL.py
```

Requirements: Python 3.10+, `hermes` in the WSL PATH, and internet access.

The WSL helper:
- Resolves upstream refs and records archive SHA-256 values.
- Installs the seven upstream skills through Hermes' security-scanned CLI.
- Copies the nine original/local skills.
- Applies the same compatibility notes.
- Runs `hermes skills audit` and validates the resulting Hermes skill tree.

To replace existing local/original custom skills only:

```bash
python3 ./Install-Hermes-WSL.py --force
```

The WSL helper does not force-replace upstream Hub-managed skills. Manage those through Hermes.

## 7. Installation destinations

- Hermes native Windows profile: `%LOCALAPPDATA%\hermes\skills\` by default (or `%HERMES_HOME%\skills\` if `HERMES_HOME` is set; the CLI may place Hub-installed skills in category subfolders).
- Hermes WSL/Linux profile: `~/.hermes/skills/` by default (or `$HERMES_HOME/skills/` if `HERMES_HOME` is set).
- OpenCode global config: `%USERPROFILE%\.config\opencode\skills\<skill-id>\SKILL.md`.

The package does not also copy the same skills into `~/.agents/skills`, avoiding a third duplicate copy. Older `.agents/skills` folders are left untouched and reported as possible duplicates. Potential old `docx`, `pdf`, `xlsx`, and `pptx` folders are also reported for manual provenance/license review. See `docs/legacy-migration.md`.

## 8. Runtime verification

After installation, restart both applications.

Hermes:

```powershell
hermes skills list
```

OpenCode:
- Restart OpenCode.
- Mention a skill explicitly, for example `@embedded-firmware-reviewer`.
- Confirm the agent loads the correct skill and can read its supporting references.

Suggested smoke tests are in `docs/activation-smoke-tests.csv`.

## 9. Token-efficiency behavior

Skills are loaded on demand. Installing 16 skills does not mean all 16 full instruction files are inserted into every prompt. Keep descriptions specific and activate only the skill(s) needed for the current task. Supporting references should be read only when relevant.

The separate `quality-first-efficiency` companion pack is not included in this 16-skill count. It can remain separate; avoid installing duplicate or conflicting context rules without reviewing `docs/skill-routing-policy.md`.

## 10. Integration and validation documents

- `docs/integration-audit-report.md` — findings, severity, and resolutions.
- `docs/skill-routing-policy.md` — ownership boundaries and cross-skill routing.
- `docs/superpowers-portability-patch.md` — missing optional Superpowers dependencies and host fallbacks.
- `docs/context-engineering-portability-patch.md` — absent sibling skills and runtime capability caveats.
- `docs/dependencies-and-platform-notes.md` — optional software dependencies.
- `docs/source-and-license-notes.md` — upstream and document-skill licensing.
- `docs/validation-plan.md` — what static and runtime validation prove.
- `docs/build-validation-summary.md` — checks actually completed during package construction.
- `docs/legacy-migration.md` — inspect and safely archive older skill copies.

## 11. Known limitations

- This is a standalone installation of four selected Superpowers skills, not the complete Superpowers plugin; its bootstrap and other optional skills are not installed.
- Subagent availability differs by host and configuration. The code-review skill has an in-session fallback.
- Document conversion/rendering dependencies are optional and must be installed separately.
- Static validation does not prove agent discovery or output quality; perform the runtime smoke tests.
- Upstream branch content can change. The installer resolves refs where possible and records commit IDs and archive SHA-256 values.
- PowerShell runtime testing must be performed on the user's Windows machine; this package-building environment does not have PowerShell installed.
