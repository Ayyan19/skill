# Battery State of Health (SOH) and Remaining Useful Life domain audit

## Define the actual target
Distinguish capacity SOH, resistance SOH, energy SOH and power SOH. A typical capacity-based measure is SOH_C = Q_measured / Q_reference × 100%, but the reference capacity, temperature, discharge rate, cutoffs and protocol must be defined. Do not assume 80% EOL is universal.

## Verify source and processing
- Exact cell chemistry, nominal/rated capacity, test temperature, voltage limits, C-rate and dataset provenance.
- Dataset identity: NASA PCoE collections, CALCE, Oxford and other datasets are distinct; verify exact download/source, file structure and measurement semantics.
- Cycle boundaries, charge/discharge segmentation, rest intervals, time alignment, missing and irregular samples.
- Current sign, integration units (A·s vs A·h), coulomb counting, capacity and resistance measurements.
- Leakage: same cell, closely adjacent cycles or overlapping windows in train/test may inflate generalization.
- Cell-to-cell vs within-cell evaluation; aging stage, temperature and protocol shift.
- MAE/RMSE in SOH fraction versus percentage points; RUL cycle or time definition.
- Confidence intervals across cells, not only windows or repeated seeds.
- Compare identical splits and fair baseline tuning; report EOL threshold and censoring.

## Claims policy
A numerical result from a public benchmark must be recalculated using the exact files, split, seeds and code. Do not attribute an Oxford or NASA dataset to an unrelated provider. Do not use a partial DOI or abstract as proof of full experimental support.
