# Example: Repeated Watchdog Reset

## Evidence to collect
- Exact MCU, framework, SDK and watchdog type.
- Full reset reason and backtrace.
- Task names, priorities, stack sizes and watchdog subscriptions.
- Long critical sections and ISR execution paths.
- Blocking I/O and busy loops.
- Heap/stack diagnostics and recent changes.

## Analysis
Distinguish interrupt watchdog, task watchdog, hardware watchdog, and application-level timeout. Their triggers and remedies differ.

## Candidate causes
- ISR or critical section blocks scheduling.
- Task fails to yield or blocks too long.
- Deadlock or priority starvation.
- Peripheral wait has no timeout.
- Watchdog feed is tied to the wrong progress condition.

## Fix policy
Do not disable the watchdog by default. Propose the smallest change that restores bounded execution and meaningful progress. Verify with logs and targeted stress tests.
