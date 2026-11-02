# Real-Time, RTOS, and Memory Review

## 1. Timing model

For each periodic or event-driven activity, record:
- Period / minimum inter-arrival time.
- Deadline.
- Worst-case execution time (measured or estimated).
- Blocking time.
- Interrupt latency.
- Jitter tolerance.
- Priority and scheduling policy.

Do not call a system real-time merely because it uses an RTOS. Deadlines and worst-case behavior must be considered.

## 2. Interrupt service routines

Check:
- ISR work is bounded and short.
- No blocking calls or waits.
- Only ISR-safe RTOS APIs are used.
- Shared state is protected correctly.
- Data is transferred to tasks using appropriate queues/notifications/atomics.
- Interrupt priority constraints match the RTOS port.
- Nested interrupt and critical-section assumptions are valid.

## 3. FreeRTOS-specific checks

When FreeRTOS is actually used:
- Task priority, stack depth, affinity (if SMP), and creation result.
- Queue/semaphore/mutex ownership and timeout.
- Priority inversion and mutex use.
- ISR-safe API variants.
- Tick rate and software timer daemon load.
- Static vs dynamic allocation strategy.
- Heap implementation and allocation failure.
- Stack high-water mark and overflow checks.
- Watchdog subscriptions and task progress.

Do not apply FreeRTOS API assumptions to Zephyr or bare-metal projects.

## 4. Zephyr-specific checks

When Zephyr is used:
- Board target and devicetree.
- Kconfig configuration.
- Device readiness and driver binding.
- Thread priorities, stack sizes, and scheduling.
- Workqueues and interrupt context.
- Memory slabs/heaps and object lifetimes.
- Logging overhead and deferred logging.
- Watchdog and power management integration.

## 5. Bare-metal checks

- Main loop worst-case duration.
- Cooperative task scheduling and starvation.
- Timer tick drift and rollover.
- Atomicity of shared variables.
- Interrupt nesting and latency.
- Sleep/wakeup race conditions.
- Work queue or event flag overflow.

## 6. Memory and resources

Check:
- Flash/RAM budget and linker map.
- Stack and heap boundaries.
- Static buffers and large globals.
- Heap fragmentation and lifetime patterns.
- DMA-capable memory and alignment requirements.
- Cache coherency on MCUs with data cache.
- External RAM/PSRAM access constraints.
- Recursion and worst-case stack depth.
- Resource leaks and peripheral handle ownership.

## 7. Watchdog policy

A watchdog should detect lack of meaningful progress. Feeding it unconditionally from a timer can hide deadlocked or failed tasks. Determine what progress is required and what recovery action is safe. Never recommend disabling a watchdog as the default solution.
