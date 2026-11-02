# Example: Gerber-Only Manufacturing Artifact Review

## Scenario
The user provides only Gerber and Excellon files.

## Allowed review
- Inventory and file naming.
- Layer mapping based on file metadata and visual/CAM inspection.
- Board outline closure and dimensions.
- Copper/mask/paste/silkscreen alignment.
- Drill tool sizes/counts and PTH/NPTH separation if files indicate it.
- Obvious copper-to-edge, mask, silkscreen and geometry concerns.
- Cross-check against a supplied fabrication drawing.

## Not supportable from Gerber alone
- Complete schematic connectivity or design intent.
- Correct component MPN and electrical ratings.
- Correct symbol-to-footprint mapping.
- DRC rule coverage or disabled rule settings.
- BOM correctness or assembly variant.
- Power-stage current capacity without copper, stackup, load, thermal and source data.
- Functional or safety validation.

## Required report label
**Interchange-artifact review — not a native project audit.**

## Request next
Ask for native project, netlist/IPC-D-356, BOM, pick-and-place, stackup, fabrication drawing, and critical component datasheets to deepen the audit.
