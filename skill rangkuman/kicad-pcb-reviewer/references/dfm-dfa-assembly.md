# Design for Manufacturing and Assembly

## 1. Fabrication DFM
Check actual supplier capabilities for:
- Track/space, copper weight, drill, annular ring.
- Via aspect ratio, via fill/cap and via-in-pad.
- Solder mask registration/sliver.
- Copper-to-edge and hole-to-hole.
- Slots, cutouts, board thickness and tolerances.
- Surface finish, impedance and material.
- Panelization, rails, tooling holes, fiducials and breakaways.

## 2. Assembly DFA
Check:
- Component spacing and body-to-body clearance.
- Polarity/pin-1 marks and readable silkscreen.
- Solder paste aperture and thermal pad segmentation.
- Tombstoning risk, shadowing and reflow access.
- Connector access, mechanical support and strain.
- Mixed technology and selective soldering constraints.
- Rework and inspection access.
- DNP/variant handling.

## 3. Pick-and-place
Verify:
- X/Y units and origin.
- Board side and bottom-side mirroring convention.
- Rotation convention and zero angle.
- Reference and value fields.
- DNP exclusion and variant selection.
- Fiducial and panel coordinate assumptions.

## 4. Testability
Check test pads, probe access, bed-of-nails clearance, programming connector, power injection, boundary scan and functional test points.

## 5. Supplier confirmation
When capabilities are ambiguous, request written confirmation from the actual fabricator/assembler. Do not infer their process from a generic capability table or another supplier's limits.
