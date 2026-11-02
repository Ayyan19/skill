# Thermal, Mechanical, and Reliability Review

## 1. Thermal inputs
Collect component losses, duty cycle, ambient, airflow, enclosure, copper geometry, board thickness, material, heatsink, interface material, and neighboring heat sources.

## 2. Thermal estimates
Separate:
- Conduction loss.
- Switching loss.
- Magnetic/core loss.
- Resistor dissipation.
- Regulator loss.
- Connector/contact loss.

Use exact datasheet thermal parameters and their stated test conditions. Board-level thermal resistance is highly dependent on copper and construction; do not apply package theta-JA blindly to a different layout.

## 3. Thermal path
Check junction-to-case/board/ambient path, exposed pads, thermal vias, copper spreading, heatsink contact, airflow and enclosure. Estimate margins and uncertainty.

## 4. Component derating
Review capacitor voltage/ripple/temperature, resistor power/voltage, MOSFET SOA, IC junction temperature, connector current/temperature, inductor saturation, and battery limits.

## 5. Mechanical
Check board outline, mounting holes, fasteners, keepouts, component height, connector mating, cable strain, vibration, shock, flex, enclosure, edge clearances, and thermal expansion.

## 6. Reliability
Consider solder joint stress, thermal cycling, humidity/corrosion, contamination, vibration, connector cycles, power cycling, and expected service life.

## 7. Evidence labels
A hand calculation is an estimate. A simulation is valid only for its model and boundary conditions. A thermal camera or thermocouple measurement is physical evidence under the documented load and ambient.
