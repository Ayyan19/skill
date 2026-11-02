# Signal Integrity, EMI/EMC, and Grounding

## 1. Signal classification
Identify clock, fast-edge digital, differential, RF, analog, switching node, current-sense, gate-drive, and external connector nets.

## 2. Return path
For each critical signal, identify its reference plane and return path. Check plane discontinuity, splits, voids, layer transitions, connector transitions, and stitching.

## 3. Controlled impedance
Require:
- Actual stackup and dielectric material data.
- Copper thickness and finished geometry.
- Trace width, spacing, reference plane and solder mask.
- Target impedance and tolerance.
- Field solver or fabricator calculation.
- Measurement coupon/TDR plan where required.

Do not infer impedance from trace width alone or claim impedance control from a CAD rule without stackup validation.

## 4. Differential pairs
Check pair polarity, width/gap, coupling, reference plane, intra-pair skew, pair-to-pair spacing, termination, via transitions, connector pinout, and common-mode path. Length matching alone does not guarantee signal integrity.

## 5. Decoupling and power integrity
Check capacitor value/derating/ESR/ESL, placement, loop area, via inductance, return path, regulator stability requirements, and transient current paths.

## 6. EMI/EMC
Check switch-node area, edge rate, gate loop, common-mode paths, cable interfaces, filter placement, shielding, chassis/earth strategy, ESD return path, and enclosure apertures.

Layout review cannot prove emissions/immunity compliance. Formal test with defined standard, setup, limits and instrumentation may be required.

## 7. Analog
Check input impedance, guard/return strategy, reference routing, ground current coupling, filter placement, thermal gradients, Kelvin sense and ADC reference decoupling.
