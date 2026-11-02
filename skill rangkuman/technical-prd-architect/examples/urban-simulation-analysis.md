# Urban Simulation — source-based PRD enhancement example

Source: user-supplied `prd urbann simulation.md`. **Illustrative audit, not an approved edited PRD.**

## Source-supported structure
The provided PRD uses Overview, Requirements, Core Features, User Flow, Architecture, Database Schema and Tech Stack. It describes a web-based electric urban race energy/strategy simulator, including vehicle dynamics, driving-line and speed optimization, no regenerative braking, mandatory full stops, real-time collaboration, a client/API/simulation architecture and data entities.

## Conflicts to flag, not silently fix
1. Requirements describe `stops_per_lap` as configurable, while Core Features specify one stop per lap and Tracks has a single `stop_position_m` and `stop_duration_s` field. Ask whether multiple stops are supported and whether stops belong to a ruleset, track or simulation run.
2. Vehicle input has `drivetrain_eff` (single scalar), while Core Features require an RPM-vs-torque motor efficiency map. Ask which losses each measures and prevent double counting.
3. A speed/path optimization runtime below 5 seconds is requested, but benchmark geometry size, optimization scope, hardware, repeat count and percentile are unspecified; record TBD, not assumed performance.
4. Regulations are named for SEM Urban and KMHE Urban, but ruleset year/edition/source and stop-specific applicability are not supplied. Do not claim a preset is officially valid.
5. Collaboration includes real-time simultaneous editing, but access permissions, simultaneous conflict semantics, offline recovery and audit trail need specification.

## Proposed enhancement (not source fact)
- ID FR-STOP-001: stop-rule representation supporting approved multiplicity; acceptance defined after owner resolves the one-vs-many conflict.
- ID NFR-OPT-001: optimization runtime target with explicit benchmark dataset, compute environment and percentile (all TBD).
- Add a run snapshot containing vehicle/track/ruleset versions and solver configuration for reproducibility.
- Add baseline physical sanity tests and infeasible-case reporting before advertising a 'minimum energy' solution.

## Source preservation rule
Never silently rewrite this project to adopt new database entities, different algorithms or architecture. Request approval after explaining the tradeoffs.
