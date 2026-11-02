# Firmware Security and Reliability

## 1. Input and memory safety

Review:
- Bounds checks on external input and serialized payloads.
- Integer overflow in lengths and offsets.
- Safe parsing and validation.
- Buffer lifetime and concurrency.
- Stack exhaustion and allocation failure.
- Format-string and logging hazards.
- Untrusted update/configuration inputs.

## 2. Communication security

Where applicable:
- Authentication and authorization.
- Secure key storage and provisioning.
- TLS configuration and certificate validation.
- Replay protection and message freshness.
- Secure pairing and BLE permissions.
- Debug interface exposure.
- Secrets in source, logs, crash dumps, and build artifacts.

Do not claim a system is secure based only on use of encryption.

## 3. Boot and firmware update

Check:
- Boot chain and image authenticity where supported.
- Rollback strategy and recovery image.
- Power-loss behavior during update.
- Version compatibility and migration.
- Flash partition layout.
- Debug lock and recovery implications.
- Key lifecycle and manufacturing provisioning.

Do not change fuses, option bytes, secure-boot settings, or debug lock state without explicit approval and a recovery plan.

## 4. Reliability

Check:
- Error detection and recovery.
- Sensor plausibility and stale-data handling.
- Persistent state integrity.
- Brownout and reset recovery.
- Long-duration resource drift.
- Watchdog coverage.
- Thermal and supply margins.
- Fault logging and diagnostic counters.

## 5. Safety vs security

Security protects against malicious or unauthorized behavior. Functional safety and electrical safety address hazards and failures. One does not imply the other. Do not claim safety certification or standards compliance unless the required process and evidence exist.
