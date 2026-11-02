# PCB Placement, Routing, and DRC Audit

## 1. Placement
- Board outline, cutouts, slots, mounting holes, edge keepouts.
- Connector access, insertion/removal and cable bend.
- Mechanical envelope and enclosure.
- Component height and 3D collision.
- Assembly/rework access.
- Thermal source spacing and airflow.
- Sensitive analog/RF separation.
- Test point and probe access.

## 2. Routing
- Trace width, clearance, neck-down and length.
- Via pad/drill, annular ring and aspect ratio.
- Unconnected items and dangling tracks.
- Plane connection, thermal relief, spokes and isolated islands.
- Return path and reference plane changes.
- Layer transitions and via placement.
- Differential pair width, gap, coupling and skew.
- High-current path and loop area.
- Copper-to-edge and hole clearance.

## 3. Ground and return path
For every fast or high-current signal, identify its return current path. Avoid arbitrary ground splits that force return currents around discontinuities. Use stitching vias and reference transitions intentionally.

## 4. DRC audit
Inspect:
- Rule values and units.
- Rule priorities and scopes.
- Disabled/excluded checks.
- Board-level minimums vs class/custom rules.
- Unconnected items.
- Copper clearance and physical clearance.
- Edge clearance, hole clearance and courtyard.
- Solder mask, silkscreen, text and mechanical layers.
- Zone refill status and stale fills.
- Severity settings and waived violations.

A DRC pass proves only that the enabled rules passed for the checked design state. Verify that the rules reflect actual requirements and manufacturer capabilities.

## 5. Exceptions
Every waiver should include owner, reason, location, risk, approval, and expiry/review status. Do not treat ignored DRC markers as automatically acceptable.

## 6. Output
Report coordinates, layer, object types, net names, actual vs required dimensions, rule source, and severity.
