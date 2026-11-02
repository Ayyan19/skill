# Schematic and Connectivity Audit

## 1. Functional architecture
Identify power entry, protection, regulation, control, sensing, communication, actuation, debug/programming, connectors, and external harnesses. Trace each power and signal path.

## 2. Pin and symbol correctness
For critical ICs:
- Compare symbol pin numbers/names/types against exact datasheet and package.
- Check hidden power pins and multi-unit symbols.
- Check exposed/thermal pads and required connections.
- Check NC pins, reserved pins, bootstrap/configuration pins, and strap requirements.
- Check connector numbering, mating orientation, and harness view.

## 3. Net semantics
Check:
- Local/global/hierarchical labels and scope.
- Power symbols and power flags.
- Net ties and intentional shorts.
- No-connect markers.
- Single-pin nets and unconnected pins.
- Duplicate references and annotation.
- Bus entries and vector indexing.
- Netlist consistency between schematic and PCB.
- DNP and assembly variants.

Net names are not proof of correct connectivity. Trace actual symbol pins and nets.

## 4. Power and protection
Check:
- Input connector polarity and reverse protection.
- Fuse location and rating basis.
- TVS/ESD placement and return path.
- Regulator topology, input/output range, dropout, thermal dissipation.
- Decoupling values and placement requirements.
- Power sequencing and reset.
- Ground references and isolation boundaries.
- Test points and power measurement access.

## 5. Signal and interface review
Check logic levels, pull-ups/down, series resistors, termination, isolation, transceivers, connector pinout, and ESD protection against the exact component datasheets.

## 6. ERC interpretation
Review ERC errors, warnings, exclusions, severities, and custom pin-type settings. A zero-error ERC result can be misleading if symbol electrical types or rule severities are incorrectly configured.

## 7. Schematic-to-PCB parity
Compare:
- Component references and values.
- Pin-to-net assignments.
- Footprint assignments.
- Unplaced/unrouted items.
- Net ties and intentional shorts.
- Variants and DNP state.
- Any ECO/difference report.

## 8. Report
For each issue, include sheet/page, reference, pin, net, evidence, consequence, confidence, and recommended correction.
