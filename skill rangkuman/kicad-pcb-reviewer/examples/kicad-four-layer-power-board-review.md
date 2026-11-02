# Example: KiCad Four-Layer Power Board Review

## Scenario
A user supplies a KiCad project for a four-layer motor-control PCB. This is a workflow example, not a claim about a real board.

## Evidence to collect
- Exact KiCad version and board revision.
- `.kicad_sch`, `.kicad_pcb`, `.kicad_pro`.
- Symbol/footprint libraries and custom rule files.
- Exact MCU, gate driver, MOSFET, shunt, connector, capacitor and protection part numbers.
- Fabricator's four-layer stackup and current capability table.
- Required voltage/current, duty, ambient and cooling conditions.
- ERC/DRC reports and BOM.

## Review order
1. Check schematic-to-PCB net parity and critical IC pin mapping.
2. Verify symbol and footprint pad numbers against manufacturer drawings.
3. Confirm stackup with actual supplier, not a generic four-layer example.
4. Review high-current loops, MOSFET/gate-driver placement, DC-link capacitors and current sensing.
5. Check DRC rule values and exclusions against supplier capability.
6. Review thermal assumptions and component derating.
7. Generate/inspect Gerber, drill, BOM and placement only after approval.

## Example finding format
- ID: PWR-001
- Severity: High (only if supported by evidence)
- Confidence: Medium
- Location: named net / component / layer / coordinate
- Evidence: cite source file, datasheet, report or measurement
- Risk: describe credible failure mode
- Recommendation: exact bounded change
- Verification: DRC, calculation, CAM or physical test needed

## Approval boundary
No source edits, manufacturing release, supplier upload, power-on, or motor actuation without separate explicit approval.
