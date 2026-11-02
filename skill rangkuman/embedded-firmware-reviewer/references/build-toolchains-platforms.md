# Build Systems, Toolchains, and Platform Notes

## 1. Build provenance

Identify:
- Build system and version.
- Compiler and linker version.
- SDK/framework version.
- Target MCU/board and package.
- Build configuration and feature flags.
- Dependency lockfiles and library versions.
- Linker script and memory map.
- Generated code and code-generation tool version.

Do not silently update dependencies during review.

## 2. Common environments

### ESP-IDF
Use the documentation matching the installed ESP-IDF release and exact ESP32 variant. Review `sdkconfig`, target selection, component dependencies, partition table, bootloader settings, linker map, and monitor/build logs.

### Arduino
Identify the exact board core and version, board FQBN, library versions, timer/resource conflicts, board-specific pin map, and compiler settings. Arduino language reference alone does not define the electrical limits of every board.

### STM32Cube
Identify exact STM32 family and package, CubeMX/CubeIDE/CubeCLT version, HAL/LL version, startup files, linker script, clock tree, DMA and NVIC setup, and generated-code boundaries.

### Raspberry Pi Pico SDK
Identify RP2040 vs RP2350, board/package, SDK version, CMake/toolchain, linker map, PIO programs, DMA and multicore usage.

### Zephyr
Identify board target, Zephyr version, west manifest, Kconfig, devicetree overlays, modules, toolchain, and generated build configuration.

### PlatformIO
Inspect `platformio.ini`, platform/framework/package versions, board ID, build flags, upload/debug settings, and dependency constraints.

## 3. Safe command policy

Read-only examples (verify exact behavior in the environment):
- Print tool versions.
- List files and configuration.
- Search symbols.
- Inspect compiler output already present.
- Read map files and logs.

Potentially mutating:
- Package installation/update.
- Dependency resolution that rewrites lock/config files.
- Build/clean commands that overwrite or delete artifacts.
- Code generation.
- Flash/upload/erase.
- Fuse/option-byte changes.
- Project formatters that rewrite files.

Ask before running potentially mutating operations if their effects are unclear or outside the user's approval.

## 4. Platform documentation

Use the official source for the exact installed version. See `official-reference-index.md`.
