# Official Reference Index

**Link relevance checked:** 2026-11-02. Documentation paths and version selectors may change. Always select the version matching the project's installed SDK and exact silicon.

## Espressif
- ESP-IDF Programming Guide: https://docs.espressif.com/projects/esp-idf/en/latest/esp32/
- GPIO & RTC GPIO: https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-reference/peripherals/gpio.html
- Watchdogs: https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-reference/system/wdts.html
- ESP-IDF stable docs: https://docs.espressif.com/projects/esp-idf/en/stable/esp32/

Use the exact ESP32 family and IDF version. The classic ESP32 GPIO documentation is not a universal pin map for ESP32-S2/S3/C-series variants.

## STMicroelectronics
- STM32 documentation portal: https://www.st.com/en/microcontrollers-microprocessors/stm32-32-bit-arm-cortex-mCUs/documentation.html
- STM32Cube ecosystem: https://www.st.com/en/development-tools/stm32cubeide.html

Select the exact family, package, datasheet, reference manual, errata, and matching HAL/LL release.

## Arduino
- Language reference: https://docs.arduino.cc/language-reference/
- Official documentation: https://docs.arduino.cc/

The board vendor's schematic and MCU datasheet remain authoritative for electrical constraints.

## Raspberry Pi microcontrollers
- Pico-series documentation: https://www.raspberrypi.com/documentation/microcontrollers/pico-series.html
- Pico SDK hardware API: https://www.raspberrypi.com/documentation/pico-sdk/hardware.html
- Pico SDK repository: https://github.com/raspberrypi/pico-sdk

Check RP2040 vs RP2350, package variant, and board-specific pinout.

## FreeRTOS
- Official documentation: https://developer.freertos.org/Documentation/00-Overview
- Kernel developer documentation: https://developer.freertos.org/Documentation/02-Kernel/02-Kernel-features/00-Developer-docs

Use the actual port and version. Check ISR API constraints, heap implementation, stack configuration, and scheduler behavior.

## Zephyr
- Official documentation: https://docs.zephyrproject.org/latest/
- API reference: https://docs.zephyrproject.org/latest/doxygen/html/index.html

Use version-matched docs, board target, devicetree, Kconfig, and west manifest.

## PlatformIO
- Documentation: https://docs.platformio.org/

Check the exact platform package, framework package, board identifier, and dependency versions.

## General rule

The index is a starting point, not a substitute for primary component documents. For every external IC, motor driver, regulator, MOSFET, sensor, transceiver, or battery, obtain the exact manufacturer's datasheet and relevant application notes. If the exact document cannot be verified, mark the associated conclusion as incomplete.
