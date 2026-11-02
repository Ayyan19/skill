# Example: time-series leakage
Given windows from 12 devices, inspect whether windows from the same device or adjacent cycles appear across training/testing. Check whether scalers were fitted on all records. Compare device-grouped and random-window metrics. Do not assert leakage if split manifest is unavailable; propose a split audit.
