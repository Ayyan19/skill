# Testability, Safety, and Risk Review

## 1. Testability
Check programming/debug interface, test points, current measurement, voltage measurement, boundary scan, functional test fixtures, connector access, and production test coverage.

## 2. Failure modes
Consider:
- Reverse input polarity.
- Input overvoltage/transient.
- Short circuit and overload.
- Open/short sensor or feedback.
- Connector mis-mating.
- Stalled/jammed motor.
- Thermal overload.
- Brownout and reset.
- Loss of communication/control.
- Battery fault and charging fault.
- Single-point failure in protection/shutdown.

## 3. Electrical safety
For hazardous voltage/energy, identify applicable standard and requirements for insulation system, creepage, clearance, dielectric withstand, protective earth, enclosure, discharge, fuse, and service access. Values depend on product category and environment; never use universal generic numbers.

## 4. Functional safety
Do not claim a design meets IEC 61508, ISO 13849, IEC 60601, automotive or other safety standards without the relevant lifecycle process, hazard analysis, architecture, component evidence, verification and certification.

## 5. Risk ranking
Use severity, likelihood, exposure, detectability and evidence confidence as separate dimensions. Do not hide uncertainty in a single numeric score.

## 6. Safe test boundary
Never instruct an unqualified user to probe live hazardous circuitry. Do not energize a board, connect a battery, command a motor, or bypass protection without explicit approval, a safe fixture, current limits, emergency stop and appropriate instruments.
