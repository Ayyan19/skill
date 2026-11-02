# Power Electronics and Current Capacity

## 1. Current-path map
Trace source connector -> fuse/protection -> switch/regulator -> copper -> connector/load -> return. Include vias, plated holes, shunts, terminals, and thermal interfaces.

Consider continuous, peak, startup, inrush, stall, regenerative, fault and transient currents separately.

## 2. Copper current capacity
Use the selected copper weight, actual geometry, plane shape, board construction, ambient, airflow, enclosure, allowable temperature rise, and relevant IPC-2152 data or a validated model.

Do not use a single simplistic trace-width formula as a universal design rule. State:
- Current waveform and duty cycle.
- Copper thickness and geometry.
- External/internal layer.
- Allowed temperature rise.
- Ambient and cooling assumptions.
- Model/standard/calculator and limits.
- Margin and uncertainty.

A plane or polygon cannot be treated as an ideal uniform conductor without examining necks, vias, spreading, and current crowding.

## 3. Vias and terminals
Check current sharing across parallel vias, plating thickness, drill, aspect ratio, thermal path, pad geometry, connector and terminal ratings. Do not assume via current from diameter alone.

## 4. Switching power stages
For buck/boost, motor inverter, gate driver, charger, or battery interface, inspect:
- Hot loop and commutation loop.
- Gate loop and Kelvin source/emitter.
- Gate resistor and pull-down.
- Bootstrap supply and refresh.
- Dead time and shoot-through risk.
- Snubber/clamp and ringing.
- DC-link decoupling and capacitor ripple current.
- Current-sense location, polarity, Kelvin routing, bandwidth and common-mode range.
- Fault signal routing and hardware shutdown.
- Thermal path and derating.

## 5. MOSFET and semiconductor checks
Use exact datasheet conditions for RDS(on), gate charge, SOA, avalanche, VDS, VGS, pulsed current, switching loss, thermal impedance, and package limitations. Do not use headline current ratings without board/thermal conditions.

## 6. Battery systems
Verify cell chemistry, series/parallel configuration, BMS, fuse interrupt rating, wiring, connectors, precharge, reverse polarity, short-circuit, undervoltage, overvoltage, overtemperature and charge limits. Do not bypass BMS or protection.

## 7. Safety stop conditions
Flag Critical/High when polarity is ambiguous, protection is absent, current path is undersized, switching can fail destructively, isolation is unclear, or fault shutdown is not credible. Do not energize the design without explicit approval and a safe test plan.
