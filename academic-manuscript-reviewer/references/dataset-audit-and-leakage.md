# Dataset provenance, preprocessing and leakage audit

## Trace the dataset
Capture dataset name, canonical URL/DOI, original publisher, licence, version, checksums, acquisition protocol, units, devices/participants, run IDs, timestamps, exclusions and sample counts. For every published dataset, verify what its label means and which data subset was actually used.

## Leakage checks
- Train/validation/test groups must not share subject, device, cell, batch or session when the target requires generalization across those groups.
- Never fit normalization, feature selection, imputation, PCA or hyperparameter tuning on held-out test data.
- For time-series forecasting, check causal availability of features and timestamps, label horizon, rolling windows and overlap across splits.
- Detect duplicates/near-duplicates, repeated measurements and near-identical windows across sets.
- Require split manifest or reproducible grouping code; no claim of zero leakage without checking.

Report per-group counts, time ranges, version, transformations, and unverified assumptions. Distinguish an intentionally transductive method from accidental leakage and assess accordingly.
