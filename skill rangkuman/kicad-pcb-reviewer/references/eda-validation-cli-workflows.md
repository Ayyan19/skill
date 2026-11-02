# EDA Validation and CLI Workflows

## General safety
- Confirm the installed EDA version before using any command.
- Run `--help` first; CLI options can change between releases.
- Treat DRC/ERC reports and CAM exports as generated artifacts. Write them to a separate review/output directory.
- Do not overwrite existing reports or manufacturing outputs.
- A report is only as reliable as the project state and enabled rule set used to generate it.
- Do not run exporters, auto-fixers, formatters, project upgraders, or library migration tools without approval if they modify source/project state.

## KiCad CLI

Start by identifying the executable and version:
```powershell
kicad-cli version
kicad-cli --help
kicad-cli pcb --help
kicad-cli sch --help
```

Check exact subcommand help for the installed version:
```powershell
kicad-cli pcb drc --help
kicad-cli sch erc --help
kicad-cli pcb export gerbers --help
kicad-cli pcb export drill --help
kicad-cli pcb export pos --help
```

Common KiCad 9 command patterns (confirm syntax with local `--help`):
```powershell
kicad-cli pcb drc --output ".\review-output\board-drc.rpt" ".\board.kicad_pcb"
kicad-cli sch erc --output ".\review-output\schematic-erc.rpt" ".\project.kicad_sch"
kicad-cli pcb export gerbers --output ".\review-output\gerber" --layers "F.Cu,B.Cu,F.Mask,B.Mask,F.Silkscreen,B.Silkscreen,Edge.Cuts" ".\board.kicad_pcb"
kicad-cli pcb export drill --output ".\review-output\drill" ".\board.kicad_pcb"
kicad-cli pcb export pos --output ".\review-output\positions.csv" --format csv --units mm ".\board.kicad_pcb"
```

Notes:
- These commands generate files. Confirm the output directory and obtain approval when required by the operating contract.
- KiCad 9 documents `pcb export gerbers` (plural) for one file per layer; the older `pcb export gerber` (singular) is deprecated.
- Use the project's own variables and board settings. Do not silently substitute defaults.
- A DRC report does not validate that the rules are complete or correct.
- A schematic ERC report does not prove PCB-to-schematic parity unless the appropriate parity check/source is used.
- For Gerber, inspect the exported set in a CAM viewer and compare it with the source board.

## Altium Designer

- Use the exact installed Altium version's DRC documentation.
- Review rule scopes, priorities, disabled rules, online vs batch DRC, and report exclusions.
- If available, inspect configured `.OutJob` files for fabrication, assembly, BOM, and validation outputs.
- A configured release workflow may include DRC, ERC, footprint comparison, Gerber, NC Drill, BOM, pick-and-place, IPC-2581, or ODB++.
- Do not launch a release or write outputs into the project without approval.
- If Altium is unavailable, review supplied reports and neutral exports and mark native source checks as blocked or partial.

## EasyEDA Standard / Pro

- Identify product edition and version.
- Review DRC rule settings and the actual generated DRC report.
- Confirm copper-area rebuild/fill state before Gerber export where applicable.
- Compare schematic, PCB, BOM, placement, Gerber, and drill exports.
- Do not assume Standard and Pro export options or native project representations are identical.
- If only images/PDFs are available, classify as visual-only review.

## EAGLE / Fusion Electronics and other EDA

- Prefer native design-rule reports and netlist exports.
- Verify CAM job settings, layer mapping, units, origin, drill mapping, and board outline.
- If the source format is not reliably parseable, use native application reports or request neutral exports.
- Never infer a DRC pass from a rendered board image.

## Result capture

For every run, record:
- Exact command and working directory.
- EDA version and board/project revision.
- Exit code.
- Report path and timestamp.
- Number/severity of violations.
- Rule exclusions/waivers.
- Any tool warnings.
- Whether the run changed project state.
