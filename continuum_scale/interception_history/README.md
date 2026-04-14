# Interception History — Forward Prediction of Colloid Retention Profiles

Excel spreadsheet for forward prediction of colloid retention profiles from
collector efficiency (η) and attachment efficiency (α) according to the
Interception History paradigm.

---

## What This Code Does

Given user-specified values of collector efficiency (η) and attachment
efficiency (α), this spreadsheet predicts profiles of retained colloids as a
function of distance from source using the Interception History paradigm
(Al-Zghoul et al., 2025). This provides a rapid, transparent forward prediction
tool that does not require running full trajectory simulations.

---

## Platform

| Platform | Notes |
|----------|-------|
| **Excel** | Only available platform |

---

## Key Input Parameters

| Parameter | Symbol | Meaning |
|-----------|--------|---------|
| Collector efficiency | η | Fraction of bulk colloids delivered to near-surface |
| Attachment efficiency | α | Fraction of near-surface colloids that attach |
| Column length | L | m |
| Grain radius | AG | m |
| Porosity | θ | — |
| Pore water velocity | v | m/s |

---

## Relationship to Upscale Module

The [`upscale/`](../upscale/) Matlab code determines η and the near-surface
efficiencies (α₁, α₂, α_RFSZ, α_reent) mechanistically from Traj-Hap
trajectory simulation output. The InterceptionHistory spreadsheet takes those
— or user-estimated — efficiency values and predicts retention profiles
directly, providing a lightweight complement to the full upscaling workflow.

---

## Reference

- Al-Zghoul, B.M., Johnson, W.P., and Bolster, D. (2025). A paradigm shift
  in colloid filtration: upscaling from grain to Darcy scale. *ARC
  Geophysical Research*, 1, 9. https://doi.org/10.5149/ARC-GR.1582

Full reference list: [`docs/references.md`](../../docs/references.md)
