# Recalculation and reproducibility protocol

1. Inventory raw data, hashes, code and environment; make working copies only after permission for writes.
2. Check datatype, dimensions, units, missing values and row count.
3. Recreate filters, exclusions, splits and preprocessing from stated steps.
4. Recalculate each metric or table from data when possible; record formula, intermediate counts, rounding and uncertainty.
5. Compare manuscript values and explain differences with precise tolerance.
6. Log environment, software packages, seed, exact command, exit code, output paths and data version.
7. Mark outputs Reproduced, Independently recalculated, Arithmetic-checked, Blocked, or Not verified.

Don't silently repair inconsistent raw data, re-tune against test data, or fabricate missing observations. A correct arithmetic identity is not proof that the experiment was conducted correctly.
