# Project Intake and Evidence Standard

## 1. Required project identity

Record before detailed review:

| Field | Required evidence |
|---|---|
| EDA product | KiCad / Altium / EasyEDA Std or Pro / EAGLE / other |
| Version | Exact application/build version |
| Project source | Native project files and revision |
| Board identity | Name, revision, date, author, variant |
| Board geometry | Outline, dimensions, cutouts, slots |
| Stackup | Layer order, copper weight, dielectric, material, finished thickness |
| Fabricator | Manufacturer and current capability table |
| Assembler | Manufacturer and process capability |
| Operating conditions | Ambient, airflow, enclosure, vibration, humidity, altitude |
| Electrical conditions | Input/output voltage, continuous/peak/fault current, frequency, duty |
| Safety requirements | Applicable product and electrical safety standards |
| Evidence | Native files, netlist, reports, BOM, Gerber, drill, drawings, datasheets |

## 2. Evidence labels

- **Confirmed:** directly supported by native source, authoritative datasheet, report, or measurement.
- **Corroborated:** supported by multiple independent sources.
- **Inferred:** derived from confirmed facts but not directly measured or stated.
- **Hypothesis:** plausible explanation awaiting a discriminating check.
- **Unknown:** insufficient evidence.
- **Contradicted:** evidence conflicts with the claim.

Every finding should identify the evidence class and confidence.

## 3. Source hierarchy

1. Exact component manufacturer's datasheet, errata, package drawing, and application notes.
2. Exact EDA version's official documentation and native project.
3. Fabricator/assembler's current written capability table and stackup quote.
4. Applicable licensed IPC/IEC/UL/other standards and amendments.
5. Official reference designs and evaluation-board documentation.
6. Reputable technical literature and validated calculators.
7. Forums and videos as leads only, not sole support for safety-critical conclusions.

## 4. Native source vs exchange evidence

- Native project + libraries + netlist enables stronger logical review.
- DRC/ERC reports show what the tool checked under the configured rules; inspect rule coverage and exclusions.
- Gerber shows plotted geometry, not complete design intent.
- Excellon describes holes/drills, not full board connectivity.
- BOM identifies parts only to the extent the fields are accurate and complete.
- Pick-and-place gives placement coordinates/orientation, not proof of correct footprint or solderability.
- IPC-D-356/IPC-2581/ODB++ may add net or manufacturing intelligence; verify version, export settings, and completeness.
- Screenshots/PDFs support visual review but do not expose all hidden layers, rules, net data, or native properties.

## 5. Measurement evidence

For any measured board result, record:
- Board revision and sample ID.
- Instrument and model.
- Probe, fixture, and connection point.
- Test voltage/current/load.
- Ambient and thermal condition.
- Measurement range, bandwidth, calibration status.
- Units, uncertainty, and repeat count.
- Pass/fail criteria and source of criteria.

## 6. Scope statement

Before conclusions, explicitly state:
- Which native sources were inspected.
- Which exports/reports were inspected.
- Which files were missing.
- Which checks were executed vs only reviewed.
- Which conclusions are impossible from the supplied artifacts.

Never upgrade "Gerber-only review" into "full PCB design audit".
