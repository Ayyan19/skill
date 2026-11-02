# Stackup and Fabrication Rules

## 1. Fabricator-specific data
Request the current capability table and quote for:
- Layer count and stackup.
- Finished board thickness and tolerance.
- Copper weight by layer.
- Dielectric material/thickness and Dk/Df data.
- Minimum track/space.
- Minimum drill, laser drill, and annular ring.
- Via types, aspect ratio, filled/capped via-in-pad.
- Copper-to-edge and hole-to-hole spacing.
- Solder-mask registration and minimum dam.
- Surface finish and impedance control.
- Slots, cutouts, controlled depth, edge plating, castellations.
- Panelization and scoring/routing limits.

Do not assume a fabricator's generic website limits apply to the selected material, layer count, copper weight, or process.

## 2. Stackup review
Check layer order, copper distribution, reference planes, dielectric thickness, symmetry, resin/glass construction, finished thickness, and controlled impedance notes.

A nominal 4-layer stackup is not enough information to calculate impedance. Need actual dielectric properties, copper thickness, geometry, solder mask, and field-solver method or fabricator confirmation.

## 3. CAD rule mapping
Compare project rules with the selected fabricator's limits:
- Clearance and minimum width.
- Via pad/drill and annular ring.
- Copper-to-edge.
- Drill-to-drill.
- Solder-mask sliver.
- Silkscreen-to-pad.
- Board outline and cutouts.
- Layer-specific constraints.
- Differential pair geometry.
- Impedance constraints.

Rules should include margin appropriate to the process; merely setting CAD values equal to a published absolute minimum can leave no process tolerance.

## 4. High voltage
Creepage and clearance depend on working voltage, transient/overvoltage category, pollution degree, material group/CTI, altitude, coating, insulation type, and applicable standard. Do not supply generic universal distances.

## 5. Via and drill
Check finished hole, tool size, plating allowance, annular ring, aspect ratio, via type, backdrill/counterbore, and drill chart. Confirm plated vs non-plated holes and slots.

## 6. Standards
IPC-2221/2222 and related standards can guide board design; IPC-2152 addresses current-carrying capacity; IPC-7351/7352 relate to land patterns. Verify the current applicable edition and licensed text. Standards do not replace fabricator process capability or product safety standards.
