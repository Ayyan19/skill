# Component, Footprint, and BOM Audit

## 1. Exact part identity
Record manufacturer, full part number including suffix, package, revision, lifecycle, datasheet URL/revision, and source. Similar family names or package outlines do not prove interchangeability.

## 2. Symbol validation
- Pin numbers and names.
- Electrical pin types.
- Hidden power pins.
- Multi-unit symbol mapping.
- Exposed pad / thermal pad representation.
- NC/reserved pins.
- Pin-1 and polarity conventions.

## 3. Footprint validation
- Pad numbering matches datasheet package drawing.
- Pad size, pitch, shape, and tolerance.
- Land pattern and solder joint requirements.
- Courtyard and assembly clearance.
- Solder-mask expansion and sliver.
- Paste aperture and thermal pad segmentation.
- Drill/plated hole and annular ring.
- Pin-1, polarity, and orientation marking.
- Exposed-pad connection and via strategy.
- 3D model is aligned and dimensionally plausible.

Do not approve a footprint from visual similarity alone.

## 4. Thermal and electrical package limits
Check package thermal resistance parameters and their test conditions. Board copper, airflow, adjacent heat sources, soldering, and enclosure can materially change thermal performance.

Check voltage/current/power/temperature derating and SOA where relevant.

## 5. BOM consistency
Compare source schematic, PCB, BOM, and pick-and-place:
- Reference designator.
- Quantity.
- Manufacturer part number.
- Value and tolerance.
- Package/footprint.
- DNP / variant.
- Manufacturer and approved alternate.
- Lifecycle and sourcing status.
- Polarity and assembly notes.

## 6. Alternate parts
An alternate must match electrical characteristics, pinout, package/land pattern, thermal behavior, timing, and compliance requirements. Flag every unverified substitution.

## 7. Output
Use `../templates/bom-review.csv` and record evidence links and verification status. Do not fabricate availability or price.
