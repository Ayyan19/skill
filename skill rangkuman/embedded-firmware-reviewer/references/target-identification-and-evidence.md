# Target Identification and Evidence Standard

## 1. Why exact identification is mandatory

Embedded designs are board-, package-, silicon-, and SDK-specific. A family name alone is insufficient. "ESP32", "STM32", "Arduino", or "Pico" may refer to different silicon, board routing, voltage limits, peripherals, and boot behavior.

Capture the following before giving pin or electrical advice:

| Item | Required detail |
|---|---|
| MCU | Full ordering code, package, revision if available |
| Board | Manufacturer, board name, revision, schematic/pinout |
| Module | Exact module SKU and antenna/flash/PSRAM variant |
| Framework | ESP-IDF, Arduino core, STM32Cube, Pico SDK, Zephyr, etc. |
| Versions | SDK, compiler, libraries, build tool |
| Power | Input source, regulator, rails, voltage tolerance, current limit |
| External ICs | Exact part number, package, module variant |
| Interface | Pin names, voltage levels, direction, pull-ups, isolation |
| Environment | Temperature, vibration, moisture, enclosure, cable length |
| Evidence | Source files, logs, measurements, test setup |

## 2. Evidence labels

Use these labels in notes and reports:

- **Confirmed:** directly shown by source code, schematic, datasheet, tool output, or measurement.
- **Corroborated:** supported by two or more independent sources.
- **Inferred:** follows from confirmed facts but has not been directly observed.
- **Hypothesis:** plausible explanation requiring a discriminating test.
- **Unknown:** insufficient information.
- **Contradicted:** evidence conflicts with the claim.

Do not silently promote an inference or hypothesis to a confirmed fact.

## 3. Source hierarchy

Use sources in this order:
1. Exact component manufacturer datasheet and errata.
2. Exact MCU reference manual, datasheet, hardware design guide, and silicon errata.
3. Official board schematic, pinout, and revision documentation.
4. Official SDK/framework documentation matching the installed version.
5. Official application notes and evaluation-board designs.
6. Maintainer documentation and source code for the exact version.
7. Reputable third-party references, clearly labeled as secondary.
8. Forums and videos only as leads, never sole authority for safety-critical conclusions.

A product page or generic tutorial is not a substitute for the exact datasheet.

## 4. Datasheet reading checklist

For each relevant device, record:
- Part number and package.
- Document number, revision, and date.
- Recommended operating conditions.
- Absolute maximum ratings (not operating targets).
- Input high/low thresholds and output levels.
- Pin current and total port/device current limits.
- Power-up/reset states and sequencing.
- Timing requirements and tolerances.
- Thermal limits and derating.
- Protection features and their limitations.
- Errata affecting the used feature.

## 5. Measurement evidence

Every measurement should include:
- Instrument and model where known.
- Probe/reference point.
- Measurement mode and range.
- Supply condition and load condition.
- Static or dynamic nature.
- Units and uncertainty/resolution if relevant.
- Whether the measurement was repeated.

A DMM reading cannot establish waveform integrity, edge timing, ringing, transient overshoot, bus protocol correctness, or PWM frequency unless the meter explicitly supports that measurement and the limitation is stated.

## 6. Intake template

Use `../templates/project-intake.md`. If key information is missing, ask for the single item that most changes the conclusion. For a pin-safety question, that is usually the exact MCU/board and schematic; for a driver interface, it is the exact driver part number and its datasheet.
