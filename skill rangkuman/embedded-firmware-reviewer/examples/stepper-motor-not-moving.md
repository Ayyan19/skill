# Example: Stepper Motor Does Not Move

## Identify first
- Exact driver IC/module and datasheet.
- Motor winding resistance/current rating.
- Motor supply and current limit.
- MCU and board.
- STEP/DIR/ENABLE wiring and polarity.
- Microstep setting and pulse timing.
- Mechanical load and limits.

## Review sequence
1. Read the driver truth table and timing requirements.
2. Verify safe enable/reset behavior without energizing the motor.
3. Trace code path from user command to pulse generation.
4. Check timer/PWM/ISR configuration and pin mux.
5. Check pulse count, frequency, high/low time, direction setup/hold.
6. Verify current configuration against motor and driver requirements.
7. Inspect fault outputs and thermal/undervoltage conditions.
8. Propose a controlled test fixture and safety limits.

## Do not
- Assume a GPIO toggles because the code calls digitalWrite().
- Use a DMM to conclude pulse timing is correct.
- Increase current or disable protections as a first diagnostic step.
- Command physical movement without explicit approval and a safe test plan.
