# Debugging and Root-Cause Analysis

## 1. Diagnostic loop

1. Define the symptom precisely.
2. Record expected vs actual behavior.
3. Establish a reproducible baseline.
4. Collect existing evidence without changing the system.
5. List competing hypotheses.
6. Rank hypotheses by evidence, likelihood, and testability.
7. Choose the least risky test that separates hypotheses.
8. Observe and record the result.
9. Update the hypothesis ranking.
10. Only then propose a fix.

## 2. Avoid common reasoning failures

- Do not replace a component merely because a software read returns zero.
- Do not assume a pin is defective based on one DMM measurement.
- Do not infer pulse width, frequency, or protocol integrity from a static voltage.
- Do not change multiple variables simultaneously unless the test design requires it.
- Do not assume a new module is known-good without verification.
- Do not treat a compiler error as a hardware fault.
- Do not treat successful compilation as proof of runtime behavior.

## 3. Instrument selection

| Instrument | Can establish | Cannot normally establish |
|---|---|---|
| DMM | Static voltage, resistance, continuity, some average values | Fast edges, detailed timing, protocol decode |
| Oscilloscope | Waveform, timing, overshoot, ringing (within probe/bandwidth limits) | Full protocol meaning without decoding/analysis |
| Logic analyzer | Digital timing and protocol decode (within sample/threshold limits) | Analog quality, voltage overshoot, current |
| Current probe/meter | Current behavior within bandwidth/range | Internal semiconductor stress without more analysis |
| Debugger | CPU state, variables, breakpoints, trace where supported | Electrical correctness of external circuit |
| Serial log | Software-reported events and state | Independent proof that the physical event occurred |

## 4. Hypothesis ledger

| Hypothesis | Supporting evidence | Contradicting evidence | Discriminating test | Status |
|---|---|---|---|---|

## 5. Root-cause statement

A confirmed root cause must identify:
- Trigger/condition.
- Fault mechanism.
- Observable effect.
- Evidence linking cause to effect.
- Why alternatives were ruled out.

If evidence is insufficient, report "leading hypothesis" rather than "root cause confirmed".
