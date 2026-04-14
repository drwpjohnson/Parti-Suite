# Correlation Equations — Collector Efficiency Calculator

Calculates favorable-condition collector efficiency (η) using published
correlation equations, providing rapid estimation of η across a range of
colloid sizes, grain sizes, fluid velocities, and solution conditions without
running full trajectory simulations.

---

## What This Code Does

Correlation equations are heuristic expressions fit to results from mechanistic
trajectory simulations run under a range of conditions. They express η as a
function of dimensionless groups representing three delivery mechanisms:

- **η_I** — interception via fluid drag alone (aspect ratio N_R)
- **η_D** — diffusion-enhanced interception (Péclet number N_Pe)
- **η_G** — sedimentation-enhanced interception (gravity number N_G)

The overall η is the sum of contributions from each mechanism. These
correlations apply **only under favorable attachment conditions** (no repulsive
barrier) — they cannot predict attachment under unfavorable conditions, where
η depends on nanoscale heterogeneity in ways not captured by mean-field
dimensionless groups.

---

## Platforms

| Platform | Notes |
|----------|-------|
| **Excel** | Spreadsheet with immediate parameter exploration |
| **Matlab (GUI)** | Interactive GUI; designated `CorrEqn` in Parti-Suite |
| **Python** | Scripting and batch calculations |

---

## Correlation Equations Implemented

Five correlation equations from the literature are implemented:

| Source | Reference | Notes |
|--------|-----------|-------|
| **RT 1976** | Rajagopalan & Tien (1976) | Original Happel-based correlation |
| **TE 2004** | Tufenkji & Elimelech (2004) | Most widely cited; includes VDW number |
| **LH 2009** | Long & Hilpert (2009) | Lattice-Boltzmann based; sphere packing |
| **NG 2011** | Nelson & Ginn (2011) | Corrects non-physical η > 1 at low velocity |
| **MHJ 2013** | Ma, Hradisky & Johnson (2013) | Hemisphere-in-cell geometry |

All equations use the Happel sphere-in-cell collector geometry except LH 2009
(sphere packing) and MHJ 2013 (hemisphere-in-cell).

---

## Key Input Parameters

| Parameter | Symbol | Units |
|-----------|--------|-------|
| Colloid radius | AP | m |
| Grain radius | AG | m |
| Superficial velocity | VSUP | m/s |
| Bed porosity | θ | — |
| Colloid density | ρ_p | kg/m³ |
| Fluid density | ρ_f | kg/m³ |
| Fluid viscosity | μ | kg/m·s |
| Combined Hamaker constant | A₁₃₂ | J |
| Temperature | T | K |

---

## Important Limitations

**1. Favorable conditions only.** Correlation equations cannot predict
attachment under unfavorable conditions. Use the trajectory codes for
unfavorable systems.

**2. Valid only within the parameter ranges used in development.** Each
correlation equation was developed from simulations run over a specific range
of colloid sizes, grain sizes, and fluid velocities. Using equations outside
these ranges — particularly at very low velocities — can produce non-physical
results (η > 1). Always check the source publication for valid parameter ranges.

**3. Gravity orientation.** The vast majority of correlation equations were
developed for flow concurrent with gravity (downward flow). Most laboratory
column experiments use upward flow. For upward-flow experiments with
microscale or non-neutrally buoyant colloids, correlation equations may
significantly mis-predict η due to incorrect treatment of η_G. The MHJ 2013
equation (Nelson & Ginn, 2011 base) partially addresses this.

**4. Correlation equations are not filtration theory.** They are approximate
fits to mechanistic simulation results. For any system that does not closely
match the conditions used in their development, mechanistic trajectory
simulations (available in `pore_scale/trajectory/`) are strongly preferred.

---

## When to Use Correlation Equations

Correlation equations are most useful for:

- **Quick parameter space exploration** — rapidly scanning how η varies with
  colloid size, grain size, velocity, or density before running full simulations
- **Comparing predictions from different equations** — understanding the spread
  in η predictions across the literature
- **Teaching and orientation** — understanding which delivery mechanism
  (diffusion, interception, or gravity) dominates for a given colloid size

For any research-grade prediction, use the mechanistic trajectory codes.

---

## References

- Johnson, W.P. and Pazmiño, E.F. (2023). *Colloid (Nano- and Micro-Particle)
  Transport and Surface Interaction in Groundwater*. The Groundwater Project.
  https://doi.org/10.21083/978-1-77470-070-9 — Section 5.3.1 (freely available)

- Rajagopalan, R. and Tien, C. (1976). Trajectory analysis of deep-bed
  filtration with the sphere-in-cell porous media model. *AIChE Journal*,
  22(3), 523–533.

- Tufenkji, N. and Elimelech, M. (2004). Correlation equation for predicting
  single-collector efficiency in physicochemical filtration in saturated porous
  media. *Environmental Science & Technology*, 38(2), 529–536.
  https://doi.org/10.1021/es034049r

- Long, W. and Hilpert, M. (2009). A correlation for the collector efficiency
  of Brownian particles in clean-bed filtration in sphere packings by a
  lattice-Boltzmann method. *Environmental Science & Technology*, 43,
  4419–4424. https://doi.org/10.1021/es802951w

- Nelson, K.E. and Ginn, T.R. (2011). New collector efficiency equation for
  colloid filtration in both natural and engineered flow conditions. *Water
  Resources Research*, 47, W05543.
  https://doi.org/10.1029/2010WR009587

- Ma, H., Hradisky, M., and Johnson, W.P. (2013). Extending applicability of
  correlation equations to predict colloidal retention in porous media at low
  fluid velocity. *Environmental Science & Technology*, 47(5), 2272–2278.
  https://doi.org/10.1021/es304124p

Full reference list: [`docs/references.md`](../../docs/references.md)
