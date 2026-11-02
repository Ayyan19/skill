# EDA Format Capabilities and Interchange Limits

## 1. KiCad

Common files:
- `.kicad_pro`: project settings.
- `.kicad_sch`: schematic.
- `.kicad_pcb`: PCB.
- `.kicad_sym`, `.pretty`: symbols and footprints.
- `.net`, `.xml`: netlist exports depending on version/workflow.
- `.kicad_wks`: worksheet.
- `.rpt`, `.json`: reports where supported.
- Gerber, Excellon, BOM, position/centroid, STEP.

Preferred path: inspect native schematic and PCB, then run matching-version ERC/DRC in a separate output location if approved.

## 2. Altium Designer

Common files:
- `.PrjPcb`: project.
- `.SchDoc`: schematic document.
- `.PcbDoc`: PCB document.
- `.SchLib`, `.PcbLib`, `.IntLib`: libraries.
- `.OutJob`: output job configuration.
- `.BomDoc`: BOM document in applicable versions.
- Reports and manufacturing outputs: Gerber, NC Drill, ODB++, IPC-2581, IPC-D-356, pick-and-place.

Native file parsing may be version- and feature-dependent. Prefer the actual Altium application, exported reports, netlists, and manufacturing data when native files cannot be interpreted reliably.

## 3. EasyEDA Standard and Pro

Identify Standard vs Pro and the exact export path/version. Native data and export formats can differ. Collect schematic, PCB, DRC settings/report, BOM, placement file, Gerber, drill, and PDF/SVG/PNG as available.

A Gerber export alone does not preserve full schematic semantics, rule scope, component metadata, or native library relationships.

## 4. Autodesk EAGLE / Fusion Electronics

When available, inspect `.sch`, `.brd`, library/device/package definitions, netlist, design rules, CAM jobs, and BOM. Verify version and source format. If files are binary or transformed, use native application exports and document the limitations.

## 5. Other EDA platforms

For OrCAD/Allegro, PADS, DesignSpark, CircuitStudio, and others:
- Identify exact application and version.
- Prefer native reports and neutral exports.
- Request a netlist and schematic PDF alongside Gerber when native source is unavailable.
- Verify coordinate origin, units, layer mapping, drill mapping, and revision.

## 6. Interchange formats

### Gerber / Gerber X2
Layer artwork and attributes. Verify units, coordinate format, polarity, apertures, file function, layer mapping, and board outline. Gerber does not inherently provide the full schematic.

### Excellon / NC Drill
Hole locations, sizes, and tool data. Verify plated/non-plated separation, slots, units, zero suppression, origin, and mapping.

### IPC-D-356
Electrical test netlist format. Useful for connectivity comparison when export is complete and parser support is validated. It does not replace schematic intent.

### IPC-2581 / ODB++
Intelligent manufacturing data containers that can carry geometry, layer, component, and net information depending on version/export. Verify completeness and CAM tool support.

### BOM and Pick-and-Place
Verify reference, manufacturer part number, value, package, quantity, DNP/variant, side, X/Y, rotation, units, and origin convention.

## 7. Capability labels

Use:
- **Native project audit**
- **Native project partial audit**
- **Interchange-artifact audit**
- **Visual-only review**
- **Blocked / insufficient source**

Do not claim a check beyond the evidence tier.
