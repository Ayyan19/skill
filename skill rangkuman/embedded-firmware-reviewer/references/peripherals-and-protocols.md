# Peripheral and Communication Audit

## 1. General checklist

For every peripheral:
- Exact MCU instance and pin mux.
- Board routing and external circuit.
- Voltage levels and direction.
- Clock source and divider.
- Timing/mode/polarity/phase.
- Interrupt or DMA ownership.
- Buffer size, lifetime, and alignment.
- Timeout and error handling.
- Reset/reinitialization behavior.
- Concurrent access and locking.
- Instrumentation available to verify it.

## 2. I2C

Check:
- 7-bit vs 10-bit address handling and address conflicts.
- SDA/SCL open-drain behavior and pull-up voltage.
- Effective pull-up resistance and bus capacitance.
- Bus speed and rise/fall time.
- Clock stretching support and timeout.
- ACK/NACK, arbitration loss, stuck-bus handling.
- Device startup time and register sequence.
- Repeated start, register address width, endianness.
- Recovery procedure consistent with the hardware design.

A successful bus scan proves only that an address acknowledged under that scan condition; it does not prove correct register configuration or valid sensor measurements.

## 3. SPI

Check:
- CPOL/CPHA mode.
- Maximum clock rate for the exact device and wiring.
- Chip-select setup/hold and inactive level.
- Bit order and word width.
- MISO tri-state behavior and bus sharing.
- DMA completion and buffer lifetime.
- Command/response framing and dummy cycles.

## 4. UART

Check:
- Baud rate tolerance and clock accuracy.
- Data bits, parity, stop bits, flow control.
- Logic voltage and transceiver requirements.
- Buffer overflow and framing/overrun errors.
- DMA/interrupt ring-buffer synchronization.
- Packet framing, length, checksum/CRC, timeout, and resynchronization.

## 5. CAN / CAN-FD

Check:
- Transceiver part number and voltage.
- Bus topology, termination, stub length, and bitrate.
- Common-mode range and isolation.
- Bit timing and sample point.
- Bus-off recovery and error counters.
- Identifier filtering, message priority, stale data.
- Fault behavior on bus loss.

Do not confuse MCU CAN controller support with the presence of a physical CAN transceiver.

## 6. ADC, timers, PWM, capture

Check:
- Timer clock tree and prescaler arithmetic.
- Counter width, rollover, update events.
- PWM frequency and duty resolution.
- Complementary output and dead-time configuration.
- Input capture edge, filtering, overflow, and timestamp units.
- ADC trigger source, sample time, DMA alignment, calibration, and saturation.
- Shared timer ownership conflicts with libraries.

## 7. Encoder, Hall, optocoupler, pulse inputs

Check:
- Output type (push-pull, open-collector, open-drain).
- Pull-up voltage and value.
- Maximum frequency and pulse width.
- Debounce/filter effects.
- Interrupt rate and ISR load.
- Edge polarity and direction logic.
- Missing pulse, stuck level, and disconnected sensor detection.

## 8. Displays and storage

For displays, verify bus speed, reset, initialization, framebuffer size, refresh timing, and power-up behavior.

For EEPROM/flash/SD:
- Write endurance and wear leveling.
- Power-loss atomicity.
- File-system consistency.
- CRC/versioning.
- Bounds and corruption recovery.
- Secure erase or data-retention requirements where relevant.
