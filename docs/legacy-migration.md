# Legacy Skill Copy Review

Earlier installers may have created skill copies in several locations:
- `%USERPROFILE%\.agents\skills`
- `%USERPROFILE%\.hermes\skills`
- `%USERPROFILE%\.config\opencode\skills`

The master installer uses:
- Hermes-native profile: `%USERPROFILE%\.hermes\skills`
- OpenCode-native global config: `%USERPROFILE%\.config\opencode\skills`

It deliberately does not delete or move old `.agents\skills` folders because that directory may also be used by Codex, Cursor, or other Agent Skills-compatible tools.

## Inspect legacy copies

```powershell
$roots = @(
  (Join-Path $HOME ".agents\skills"),
  (Join-Path $HOME ".hermes\skills"),
  (Join-Path $HOME ".config\opencode\skills")
)
$names = @(
  "systematic-debugging",
  "requesting-code-review",
  "verification-before-completion",
  "writing-plans",
  "context-optimization",
  "context-compression",
  "filesystem-context",
  "docx",
  "pdf",
  "xlsx",
  "pptx",
  "embedded-firmware-reviewer",
  "kicad-pcb-reviewer",
  "academic-manuscript-reviewer",
  "technical-prd-architect",
  "creative-content-reviewer"
)

foreach ($root in $roots) {
  foreach ($name in $names) {
    $path = Join-Path $root $name
    if (Test-Path -LiteralPath $path) {
      Write-Host "Legacy copy found: $path"
    }
  }
}
```

For Hermes category directories, search recursively for `SKILL.md` and inspect its frontmatter `name`; the skill may not sit directly at the root.

## Special review: old Anthropic document skills

The earlier package referenced `anthropics/skills` for `docx`, `pdf`, `xlsx`, and `pptx`. The master package does not install those folders because of their per-skill license restrictions. If matching folders exist, verify their provenance and terms before retaining or using them.

## Existing upstream skills in Hermes

- If installed through Hermes Skills Hub, use `hermes skills list`, `hermes skills check`, `hermes skills update`, or `hermes skills uninstall` as appropriate.
- If an earlier script copied upstream folders directly into `~/.hermes/skills`, archive those manual folders before running the master installer. Do not manually remove Hub-managed records or quarantine data.
- The master installer refuses to overwrite existing upstream Hermes skills, even with `-Force`, so it does not bypass the Hub registry or security scanner.


### Archive earlier manually copied Hermes upstream folders

Only use this for folders that were copied manually by an older script. If `hermes skills list` identifies them as Hub-managed, use `hermes skills uninstall <skill-id>` instead.

```powershell
$hermesRoot = Join-Path $HOME ".hermes\skills"
$backupRoot = Join-Path $HOME (".skill-install-backups\legacy-hermes-" + (Get-Date -Format "yyyyMMdd-HHmmss-fff"))
$names = @(
  "systematic-debugging",
  "requesting-code-review",
  "verification-before-completion",
  "writing-plans",
  "context-optimization",
  "context-compression",
  "filesystem-context"
)

foreach ($name in $names) {
  $source = Join-Path $hermesRoot $name
  if (Test-Path -LiteralPath $source) {
    New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null
    Move-Item -LiteralPath $source -Destination (Join-Path $backupRoot $name)
  }
}
```

If a skill is nested under a category folder, inspect its `SKILL.md` frontmatter and move only the confirmed manual copy. Never move `.hub` registry or quarantine folders.

## Safe manual archive

Only after confirming that no other agent depends on the shared copies and that you have identified the source/licensing status, archive rather than delete:

```powershell
$legacyRoot = Join-Path $HOME ".agents\skills"
$backupRoot = Join-Path $HOME (".skill-install-backups\legacy-agents-" + (Get-Date -Format "yyyyMMdd-HHmmss-fff"))
$names = @(
  "systematic-debugging",
  "requesting-code-review",
  "verification-before-completion",
  "writing-plans",
  "context-optimization",
  "context-compression",
  "filesystem-context",
  "embedded-firmware-reviewer",
  "kicad-pcb-reviewer",
  "academic-manuscript-reviewer",
  "technical-prd-architect",
  "creative-content-reviewer"
)

foreach ($name in $names) {
  $source = Join-Path $legacyRoot $name
  if (Test-Path -LiteralPath $source) {
    New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null
    Move-Item -LiteralPath $source -Destination (Join-Path $backupRoot $name)
  }
}
```

Do not archive `docx`, `pdf`, `xlsx`, or `pptx` folders without first confirming their origin, applicable terms, and whether another tool relies on them.
