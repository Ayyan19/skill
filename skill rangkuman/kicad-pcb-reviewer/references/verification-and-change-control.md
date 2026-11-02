# Verification and Change Control

## 1. Before modification
- Record source revision and file hashes.
- Confirm native EDA version and libraries.
- Identify exact files/objects to change.
- Save a backup or create a version-control checkpoint.
- Prepare the change plan and wait for approval.

## 2. After approved change
- Inspect the diff and affected objects.
- Re-run relevant ERC/DRC.
- Compare before/after reports.
- Refill zones and update derived geometry only if approved and needed.
- Export manufacturing outputs to a separate candidate directory.
- Inspect CAM and compare source parity.
- Update BOM and placement if affected.
- Record unresolved warnings and waivers.

## 3. Evidence statuses
- **Passed:** executed and passed with report/log.
- **Failed:** executed and failed.
- **Blocked:** unavailable due to missing tool, source, license, or hardware.
- **Not run:** not attempted.
- **Not applicable:** genuinely irrelevant.

## 4. Approval separation
Separate approvals are required for:
1. Editing native schematic/PCB.
2. Changing project rules/libraries.
3. Generating/replacing manufacturing outputs.
4. Sending/uploading files to supplier or placing an order.
5. Physical power-on, high-voltage/high-current testing, or connecting actuators.

## 5. Rollback
Record changed files, backup location, diff, and exact restoration steps. Do not overwrite the only copy of a user's project.
