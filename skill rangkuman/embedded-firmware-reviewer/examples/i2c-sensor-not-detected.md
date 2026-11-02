# Example: I2C Sensor Not Detected

## Symptom
A sensor does not appear in an I2C scan.

## Safe diagnostic sequence
1. Confirm exact MCU/board, sensor IC/module variant, supply, and schematic.
2. Confirm SDA/SCL pin mapping from the board schematic and MCU docs.
3. Measure sensor supply and ground at the sensor pins.
4. Verify pull-up rail voltage and effective resistance; check for multiple parallel pull-ups.
5. Confirm address format (7-bit vs shifted 8-bit), bus speed, and controller instance.
6. Inspect initialization result and bus error codes.
7. Use an oscilloscope or logic analyzer to inspect SDA/SCL if static checks pass.
8. Consider sensor reset, power sequencing, soldering, and bus capacitance.
9. Only then rank sensor damage as a hypothesis.

## Important limits
- A DMM reading near the pull-up voltage does not prove valid I2C edges.
- An empty scan does not by itself prove the sensor is damaged.
- A replacement sensor failing identically may indicate a shared wiring, power, pin, address, or software issue.
- Do not recommend replacing components without supporting evidence.
