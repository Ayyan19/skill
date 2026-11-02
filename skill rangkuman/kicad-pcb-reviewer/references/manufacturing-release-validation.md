# Manufacturing Data and Release Validation

## 1. Release manifest
Record board name/revision, source commit, EDA version, date, variant, stackup, fabrication supplier, assembly supplier, and file checksums.

## 2. Expected outputs
As required by the supplier:
- Top/bottom and inner copper Gerber.
- Solder mask and paste layers.
- Silkscreen and fabrication layers.
- Board outline/cutouts.
- Excellon/NC Drill files, plated/non-plated as required.
- Drill drawing and fabrication notes.
- Stackup and impedance notes.
- BOM and approved alternates.
- Pick-and-place/centroid.
- Assembly drawing and polarity notes.
- IPC-D-356 / IPC-2581 / ODB++ where requested.
- STEP/3D model if useful.

## 3. CAM checks
- All required layers present and mapped correctly.
- Correct units, precision, coordinate format, origin and polarity.
- Board outline is closed and unambiguous.
- Slots/cutouts and NPTH/PTH are correct.
- No unexpected missing/empty layers.
- Copper/mask/paste/legend registration makes sense.
- Drill tools and counts match expected features.
- Compare CAM view with native board and mechanical drawing.

## 4. Source parity
Compare released files to the approved source revision. Re-export after source changes. Do not mix files from different revisions or variants.

## 5. File integrity
Check file inventory, naming, duplicate/stale outputs, archive integrity, and SHA-256 hashes. Preserve the release manifest.

## 6. Release gate
A release is not ready if:
- Critical/high findings remain unresolved.
- ERC/DRC not run or report is stale where required.
- Fabricator stackup/capability is unknown for critical dimensions.
- CAM layer mapping is ambiguous.
- BOM/placement variant mismatch exists.
- Required safety/impedance/thermal evidence is missing.

## 7. Approval
Generating a release candidate may be permitted only after approval. Sending files, uploading to a manufacturer portal, or placing an order requires separate explicit approval.
