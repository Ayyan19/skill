# Testing and Verification Strategy

## 1. Verification layers

- **Static review:** source inspection, compiler diagnostics, lint, static analysis.
- **Unit test:** deterministic logic isolated from hardware.
- **Component test:** driver/peripheral behavior with mocks, loopback, or test fixtures.
- **Integration test:** multiple firmware modules or peripherals together.
- **Simulation:** model-based behavior under declared assumptions.
- **Hardware-in-the-loop:** real controller connected to controlled plant/fixture.
- **Physical validation:** actual board and system under documented test conditions.

These layers are not interchangeable. State exactly which were performed.

## 2. Build verification

Record:
- Exact command.
- Working directory.
- Toolchain and SDK versions.
- Board/target configuration.
- Exit code.
- Warnings and errors.
- Artifact path and timestamp where useful.

Do not claim "build passed" from a partial log or an old artifact.

## 3. Test matrix

For each requirement, specify:
- Requirement ID.
- Initial conditions.
- Input/stimulus.
- Expected result.
- Observed result.
- Pass/fail/blocked.
- Evidence artifact.
- Safety controls.

## 4. Failure and boundary tests

Where relevant, test:
- Missing/disconnected sensor.
- Invalid/out-of-range reading.
- Bus timeout or stuck bus.
- Brownout and restart.
- Watchdog timeout.
- Queue/buffer overflow.
- Sensor saturation and stale data.
- Limit switch and emergency stop.
- Actuator jam/stall.
- Communication loss.
- Repeated power cycles.
- Boundary values and rollover.

Only perform physical fault injection with explicit approval and a safe test fixture.

## 5. Regression

After a change:
- Re-run the failing test.
- Run affected unit/integration tests.
- Check neighboring functionality.
- Inspect diff for unintended changes.
- Record remaining untested cases.

## 6. Evidence wording

Use:
- **Passed:** command/test was executed and passed.
- **Failed:** executed and failed.
- **Blocked:** could not execute due to missing tool/hardware/configuration.
- **Not run:** not attempted.
- **Not applicable:** genuinely irrelevant to this target.

Never report a blocked or not-run test as passed.
