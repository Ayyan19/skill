# Motor, Actuator, and Power Safety Review

## 1. Scope

Applies to stepper, brushed DC, BLDC/PMSM, servo, solenoid, relay, heater, battery-powered systems, and switching power converters.

Treat moving parts, stored energy, batteries, high voltage/current, and thermal hazards as safety-critical.

## 2. Identify the full control chain

Document:
MCU pin -> interface/isolator -> gate or motor driver -> power switches -> motor/actuator -> mechanical load.

Identify exact part numbers and datasheets for every stage. Do not assume a controller board exposes raw logic-level signals or that a driver input is 3.3 V compatible.

## 3. Startup and fault state

Check:
- MCU reset and boot pin states.
- Driver enable default and pull resistors.
- PWM output during reset/reflash/brownout.
- Driver fault output polarity and handling.
- Independent hardware disable path.
- Emergency stop and limit switch architecture.
- Safe state on communication loss or sensor timeout.
- Restart behavior after watchdog reset or power restoration.

## 4. Stepper motor

Check:
- STEP pulse minimum high/low time.
- DIR setup/hold relative to STEP.
- ENABLE polarity and startup state.
- Microstep configuration and current setting.
- Acceleration/deceleration and pulse rate.
- Stall, missed-step, limit, and homing behavior.
- Mechanical end stops and cable/gear failure modes.

Do not infer motor movement or torque from STEP pulses alone.

## 5. BLDC / gate driver / inverter

Check:
- Gate-driver supply and logic thresholds.
- MOSFET ratings and gate charge.
- Dead time and shoot-through prevention.
- Bootstrap constraints and refresh.
- Current-sense topology, amplifier range, offset, and calibration.
- Overcurrent/short-circuit response.
- DC-link capacitor and switching loop.
- Thermal design and derating.
- Fault latch/clear behavior.
- Hall/encoder/observer alignment and loss-of-feedback response.

A software command to disable PWM is not necessarily an independent safety mechanism.

## 6. Battery and power systems

Check:
- Chemistry and series/parallel configuration.
- BMS and cell-level protections.
- Fuse placement and interrupt rating.
- Wire, connector, PCB, and switch current rating.
- Precharge/inrush where applicable.
- Reverse polarity and short-circuit protection.
- Undervoltage/overvoltage/overtemperature behavior.
- Isolation and enclosure.
- Safe charge/discharge limits from cell and BMS datasheets.

Do not invent battery limits or recommend bypassing BMS protections.

## 7. Approval boundary

The skill may inspect control code and propose tests. It must not:
- Flash firmware that can energize an actuator without explicit approval.
- Command a motor, heater, relay, or power stage to operate.
- Change current limits, protection thresholds, fuses, option bytes, or safety interlocks.
- Recommend live probing of hazardous circuits without a suitable instrument, rated probe, isolation, and competent procedure.

Physical test approval must be explicit and separate from source-code edit approval.
