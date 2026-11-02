# Electrical Interface Audit

## 1. Power-domain map

Create a table of every rail and connected device:

| Rail | Nominal | Min/max | Source | Loads | Protection |
|---|---:|---:|---|---|---|
| Logic rail | TBD | TBD | TBD | MCU/sensors | TBD |
| Actuator rail | TBD | TBD | TBD | Motor/driver | TBD |

Do not assume two devices are 3.3 V tolerant because their boards are powered from USB or have a 3.3 V regulator. Verify signal pin tolerance separately.

## 2. GPIO compatibility

For each signal, verify:
- MCU pin and package pin number.
- Board header label and actual schematic net.
- Input/output/open-drain direction.
- Voltage range and absolute maximum.
- VIH/VIL and VOH/VOL compatibility.
- Source/sink current and aggregate port limits.
- Internal/external pull-up/down requirements.
- Boot/strapping/debug/flash reservation.
- Alternate function, timer, ADC, interrupt, DMA constraints.
- Reset and unpowered behavior.
- External contention or back-power paths.

Never treat absolute maximum ratings as normal operating limits. Do not directly connect incompatible voltage domains.

## 3. Pull-up and series resistors

For open-drain buses such as I2C:
- Verify which devices are open-drain and which have internal pull-ups.
- Determine the effective parallel pull-up resistance.
- Check bus capacitance, bus speed, rise-time requirement, sink current, and low-level voltage.
- Check voltage domain: a pull-up to 5 V may damage a non-5-V-tolerant MCU.
- Do not add pull-ups or series resistors by habit.

For series resistors:
- Identify their purpose (edge damping, current limiting, protection, level shifting network).
- Check their effect with driver impedance, line capacitance, edge rate, frequency, and input thresholds.
- Do not claim a series resistor blocks data without a circuit/timing basis.

## 4. ADC and analog inputs

Check:
- Allowed pin/channel for the exact package.
- Reference voltage and attenuation/gain configuration.
- Input range, source impedance, sample-and-hold acquisition time.
- Resolution vs effective number of bits.
- Calibration, offset, gain error, noise, filtering.
- Divider loading and resistor tolerance.
- RC filter settling and bandwidth.
- Protection against negative voltage and transients.
- Interaction with radio/peripheral modes where documented.

Do not convert raw ADC counts to voltage without the correct reference, attenuation, calibration, and transfer function.

## 5. Power integrity and protection

Review:
- Regulator input/output range, dropout, transient response, thermal dissipation.
- Peak and continuous current, startup/inrush, motor stall current.
- Decoupling value, placement, return path, and datasheet requirements.
- Reverse-polarity, overcurrent, overvoltage, ESD, surge, and transient protection.
- Fuse type, interrupt rating, time-current behavior, and DC rating.
- Brownout behavior and reset sequencing.
- Ground return and high-current path separation.
- Isolation, creepage, clearance, and touch safety where applicable.

Never size a fuse or wire solely from nominal load current. Account for fault current, source capability, conductor rating, environment, and applicable standards.

## 6. Calculation discipline

Every calculation must show:
- Formula.
- Input values and source.
- Units.
- Assumptions.
- Result and margin.
- What is not included.

If an input is unknown, present a symbolic formula or request the value. Do not invent typical values and present them as measured design values.

## 7. Stop conditions

Stop and flag as Critical/High when:
- A signal may exceed the MCU absolute maximum.
- A power stage may activate unexpectedly.
- The supply, ground, or polarity is ambiguous.
- Battery protection or current limiting is absent/unknown in a hazardous design.
- Isolation/clearance requirements are unknown for hazardous voltage.
- An actuator can move without an independent stop mechanism.
