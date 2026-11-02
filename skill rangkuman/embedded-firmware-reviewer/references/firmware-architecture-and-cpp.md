# Firmware Architecture and C/C++ Review

## 1. Architecture

Inspect:
- Module boundaries and dependency direction.
- Hardware abstraction and board-specific configuration.
- Initialization and shutdown sequence.
- State machines and state ownership.
- Error propagation and recovery.
- Configuration and compile-time feature flags.
- Versioned interfaces and compatibility.
- Testability without physical hardware.

Prefer explicit interfaces and ownership. Avoid global mutable state unless justified and synchronized.

## 2. C/C++ correctness

Review:
- Array bounds and buffer lengths.
- Pointer validity, lifetime, aliasing, and ownership.
- Signed/unsigned conversions and integer overflow.
- Narrowing conversions and implicit promotions.
- Uninitialized values and invalid enum states.
- Undefined behavior and data races.
- Format strings and serialization sizes.
- `volatile` misuse: it is not a general thread-synchronization primitive.
- Atomic operations and memory ordering where relevant.
- Exceptions/RTTI settings only when target toolchain and project policy are known.
- Stack usage and large local buffers.

## 3. Embedded-specific design

Check:
- Dynamic allocation in time-critical paths.
- Fragmentation and allocation failure.
- Blocking delays in cooperative loops.
- Unbounded loops and waits.
- Debounce and input filtering.
- Unit consistency (ticks, microseconds, milliseconds, radians, degrees, counts).
- Timer rollover-safe comparisons.
- Fixed-point vs floating-point assumptions.
- Calibration persistence and version migration.
- Watchdog servicing tied to genuine progress rather than unconditional feeding.

## 4. State machine review

For each state:
- Entry conditions.
- Exit conditions.
- Allowed transitions.
- Timeout behavior.
- Error transitions.
- Safe output state.
- Recovery path.
- Invalid or stale input behavior.

A state machine should not silently continue with stale sensor values after communication failure.

## 5. Initialization and shutdown

Verify:
- Safe GPIO output levels before enabling power stages.
- Peripheral initialization order and dependency.
- Clock setup before timing-sensitive peripherals.
- Interrupt enable order.
- DMA buffers and alignment where required.
- Error handling for every initialization result.
- Shutdown behavior and output deactivation.
- Brownout/reset recovery.

## 6. Maintainability

Check naming, units, constants, comments, duplicate logic, configuration sprawl, generated vs hand-written files. Do not rewrite style unrelated to a defect unless asked.
