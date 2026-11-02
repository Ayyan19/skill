# Example: BLDC Power Stage Review

## Scope
Review a three-phase inverter or motor controller PCB. This is a checklist example, not an electrical design or validated reference circuit.

## Required inputs
- Bus voltage range and transient maximum.
- Continuous, peak and fault current.
- Motor phase current and operating envelope.
- Switching frequency and modulation method.
- Exact gate-driver and MOSFET part numbers.
- Shunt/current-sense topology and amplifier.
- Battery chemistry, BMS and fuse details.
- Copper stackup, cooling and enclosure.
- Fabricator capability and applicable safety requirements.

## Review path
1. Trace battery connector, fuse, reverse protection, precharge and DC-link.
2. Inspect half-bridge topology, MOSFET pinout, gate loops and driver decoupling.
3. Verify bootstrap/charge-pump constraints and dead-time requirements from exact driver datasheet.
4. Review switching loop, DC-link capacitor placement and return path.
5. Review shunt/Kelvin routing, current amplifier common-mode range, bandwidth and calibration.
6. Review fault outputs, hardware shutdown and MCU reset defaults.
7. Estimate conduction/switching loss using sourced parameters and operating conditions.
8. Check copper, via, terminal and connector thermal/current margins.
9. Check EMI paths, thermal spreading, mechanical support and manufacturing rules.
10. Define a staged bring-up and test plan with current-limited supply and independent shutdown.

## Do not
- Assume a 48 V nominal bus is the maximum transient voltage.
- Size copper from nominal battery current alone.
- Ignore regenerative current or motor stall current.
- Claim safe operation from DRC or a 3D render.
- Recommend bypassing BMS, fuse, overcurrent, thermal or gate-driver protections.

## Release gate
A high-energy board remains **Not ready** until electrical ratings, protection, thermal margins, manufacturing capability and a safe validation plan are supported by evidence.
