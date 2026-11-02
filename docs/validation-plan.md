# Integration Validation Plan

## Static package validation
- [ ] All 16 skill IDs appear exactly once in the manifest.
- [ ] Every local skill has a `SKILL.md`.
- [ ] Each `SKILL.md` has YAML frontmatter, matching `name`, and a non-empty description of 60 characters or fewer.
- [ ] Names meet Agent Skills/OpenCode slug rules.
- [ ] Referenced local reference/template/example files exist.
- [ ] Upstream source license is copied into each selected upstream skill folder at install time.
- [ ] Superpowers portability notes are applied and recorded.

## Installation validation
- [x] WSL helper passes `python3 -m py_compile Install-Hermes-WSL.py`.
- [ ] Run PowerShell validation on Windows.
- [ ] Download and extract both upstream archives.
- [ ] Validate all 16 staged skills before touching installed directories.
- [ ] Preflight all destination collisions.
- [ ] Back up existing destinations when `-Force` is specified.
- [ ] Copy and validate each target skill for each selected platform.
- [ ] Roll back changed targets if any install/validation step fails.
- [ ] Record source refs and archive SHA-256 values.

## Runtime validation on Windows (must be performed by the user)
- [ ] Run `hermes skills list`; confirm all 16 skills are visible.
- [ ] Restart OpenCode and test `@systematic-debugging`.
- [ ] Test one original document workflow, e.g. `@word-document-workflow`.
- [ ] Test one custom domain skill, e.g. `/embedded-firmware-reviewer`.
- [ ] Confirm references are loaded only when the relevant skill is activated.
- [ ] Confirm no duplicate or shadowed IDs from older `.agents/skills` installations.

## Not proven by static validation
- Host discovery, model routing quality, subagent behavior, external tool availability, file rendering, firmware/PCB correctness, or domain-specific task success.
