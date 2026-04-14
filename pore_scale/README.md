# Pore Scale — Colloid Trajectory Simulation

This module provides mechanistic Lagrangian trajectory simulations of colloidal
particle transport and deposition in representative collector geometries. Each
simulated trajectory integrates a full force and torque balance forward in time
until the particle attaches, exits the domain, or the simulation time limit is
reached. Running a population of trajectories yields collector efficiency,
attachment efficiency, residence time distributions, and attachment location
statistics that can be directly compared with pore-scale experiments and
upscaled to continuum-scale transport predictions.

---

## Background

### The Collector Concept

Pore-scale colloid transport is simulated in a **collector** — a representative
unit cell consisting of a grain plus its surrounding fluid domain. The collector
captures the essential features of colloid transport in granular media:

- A **forward flow stagnation zone (FFSZ)** where fluid impinges on the grain
  surface and colloid delivery to the surface occurs
- A **near-surface fluid domain** (within ~200 nm of the grain surface) where
  colloid-surface interactions are significant and govern attachment or
  re-entrainment
- A **rear flow stagnation zone (RFSZ)** where low fluid velocity allows
  colloids to accumulate near the surface via secondary minimum interactions
- A **bulk fluid domain** (beyond ~200 nm) where colloid-surface interactions
  are negligible and transport is governed by fluid drag, diffusion, and gravity

The fraction of colloids entering the collector that attach is the **collector
efficiency (η)**. Under favorable conditions (opposite-charged surfaces), η
reflects the fraction of streamlines that deliver colloids to the surface. Under
unfavorable conditions (like-charged surfaces), η is reduced — sometimes by
orders of magnitude — by the repulsive energy barrier, and attachment occurs
primarily via nanoscale heterodomains on the grain surface.

### Force and Torque Balance

At each timestep, the trajectory codes solve the Langevin equation to update
colloid velocity based on all forces acting in the normal and tangential
directions relative to the grain surface:

**Normal direction:**
- Colloid-surface interaction forces (VDW, EDL, Born, LAB, steric)
- Normal fluid drag (Goldman-Cox-Brenner lubrication corrections)
- Normal gravity
- Lift

**Tangential direction:**
- Tangential fluid drag
- Tangential gravity
- Brownian diffusion (Langevin stochastic force)

The timestep is set as a multiple of the particle momentum relaxation time
(dTMRT), with separate multipliers for the bulk fluid (MULTB), near-surface
(MULTNS), and contact (MULTC) zones to balance computational efficiency with
numerical accuracy. Diffusion is turned off in the contact zone.

### Attachment and Detachment

**Perfect sink mode (ATTMODE=0):** any colloid reaching contact separation
distance is immediately considered attached. Used for rapid estimation of
collector efficiency and for comparison with correlation equations.

**Torque balance mode (ATTMODE=1):** attachment requires that the arresting
torque (arising from colloid-surface adhesion forces acting over a contact
radius) exceeds the mobilizing torque (arising from fluid drag acting over a
lever arm set by the asperity height). This physically realistic mode reproduces
the attachment and detachment behaviors observed in pore-scale experiments.
JKR contact mechanics govern the elastic deformation of the contact area and
the work of adhesion.

**Detachment simulations:** the trajectory codes can read in attached and
retained populations from a previous simulation and re-run them under altered
conditions (changed ionic strength, flow velocity, zeta potentials) to simulate
perturbation-driven detachment and re-entrainment.

### Surface Heterogeneity

Under unfavorable conditions, attachment occurs via discrete representative
nanoscale heterogeneity (DRNH) — nanoscale zones of opposite charge
(heterodomains) on the grain and/or colloid surface. The trajectory codes
implement a tiled heterodomain system that tracks the fractional overlap of the
zone of colloid-surface interaction (ZOI) with heterodomains (AFRACT) at each
near-surface timestep. Attachment becomes possible when AFRACT is sufficient
to overcome the repulsive barrier.

Supported heterodomain modes:
- **HETMODE=1** — uniform heterodomain size (RHET0 only)
- **HETMODE=9** — bimodal size distribution (1 large + 8 medium per patch)

Heterodomains can be placed on the collector surface (SCOV), the colloid
surface (SCOVP), or both.

---

## Collector Geometries

### `trajectory/happel/` — Happel Sphere-in-Cell ⭐ Recommended starting point

The Happel sphere-in-cell collector represents a spherical grain surrounded by
a concentric fluid shell whose thickness is set by the bed porosity. The
analytical Stokes flow field (Happel, 1958) makes this the most computationally
efficient spherical-grain geometry and the most thoroughly validated collector
in Parti-Suite.

**Platforms:** Fortran, Matlab (GUI), Python  
**Status:** Full functionality — heterogeneity, roughness, detachment, parallel

The Matlab GUI provides real-time visualization of trajectories, forces, and
near-surface diagnostics and is the recommended starting point for new users.
The Fortran and Python codes support parallelized production runs via SLURM.

**Advantages of the Happel geometry:**
- Analytical flow field — fast and exact
- Porosity represented through fluid shell thickness — any porosity supported
- Captures FFSZ (colloid delivery), RFSZ (secondary minimum retention), and
  equatorial region (torque-balance zone)

**Limitations:**
- Non-stackable — grain-to-grain contacts and between-grain transport are
  not represented
- Assumes complete fluid mixing at the outer cell boundary

📺 Videos: [GUI Introduction](https://youtu.be/tOQ6gz2bI2E) ·
[Favorable conditions](https://youtu.be/kDuP98YLFow) ·
[Collector efficiencies](https://youtu.be/UBFmm3_hjm4) ·
[Unfavorable conditions](https://youtu.be/iONHPUl8mkM) ·
[Perturbation/detachment](https://youtu.be/GjOIg4Fb-_I)

The Happel geometry also supports simulation of **rod-shaped colloids**
(explicit rotational dynamics) — see [`trajectory/happel/rod_shaped/`](trajectory/happel/rod_shaped/).

See [`trajectory/happel/README.md`](trajectory/happel/README.md) for full
documentation.

---

### `trajectory/impinging_jet/` — Impinging Jet

Flat collector plate with radial stagnation-point flow field. Directly
comparable to laboratory radial stagnation flow deposition cell experiments,
making it the preferred geometry for comparison with impinging jet direct
observation experiments.

**Platforms:** Fortran, Python  
**Status:** Full functionality — heterogeneity, roughness, detachment, parallel

The impinging jet geometry focuses on the forward stagnation zone and is faster
per trajectory than the Happel geometry due to a simpler (polynomial) flow
field and planar geometry.

See [`trajectory/impinging_jet/README.md`](trajectory/impinging_jet/README.md)
for full documentation.

---

### `trajectory/parallel_plate/` — Parallel Plate

Flat collector with channel (Poiseuille) flow. Directly comparable to parallel
plate direct observation experiments. Gravity-driven longitudinal transport
makes this geometry particularly appropriate for studying gravitational
sedimentation effects.

**Platforms:** Fortran only  
**Status:** Full functionality

See [`trajectory/parallel_plate/README.md`](trajectory/parallel_plate/README.md)
for full documentation.

---

### `trajectory/dense_cubic_packing/` — Dense Cubic Packing

Stackable unit cell with grain-to-grain contacts at fixed porosity (0.27).
Analytical flow field. Unlike the Happel geometry, grain-to-grain contacts are
represented, and cells can be stacked to explore trajectory persistence across
multiple grains. Fixed porosity is the primary limitation relative to the
Happel geometry.

**Platforms:** Fortran only  
**Status:** Partial functionality — surface heterogeneity not yet implemented

See [`trajectory/dense_cubic_packing/README.md`](trajectory/dense_cubic_packing/README.md)
for full documentation.

---

### `trajectory/hemisphere_in_cell/` — Hemisphere-in-Cell

Spherical grain with grain-to-grain contacts; grain centers oriented
perpendicular to flow. Numerical (rather than analytical) flow field, which
increases computational cost relative to the Happel and cubic packing
geometries.

**Platforms:** Fortran only  
**Status:** Partial functionality

See [`trajectory/hemisphere_in_cell/README.md`](trajectory/hemisphere_in_cell/README.md)
for full documentation.

---

### `correlation_equations/` — Collector Efficiency Correlation Equations

Calculates favorable-condition collector efficiency (η) using published
correlation equations from multiple authors, providing rapid estimation of η
across a range of colloid sizes, grain sizes, fluid velocities, and solution
conditions without running full trajectory simulations.

**Platforms:** Excel, Matlab, Python

Useful for:
- Quick parameter space exploration under favorable conditions
- Comparison of η from different correlation equations in the literature
- Establishing a baseline η before running full trajectory simulations

See [`correlation_equations/README.md`](correlation_equations/README.md) for
the list of correlation equations implemented and usage instructions.

---

## Choosing a Geometry

| Goal | Recommended geometry |
|------|---------------------|
| Learning the codes / first simulations | Happel (Matlab GUI) |
| Comparison with packed column experiments | Happel (Fortran or Python) |
| Comparison with impinging jet lab experiments | Impinging jet |
| Comparison with parallel plate lab experiments | Parallel plate |
| Exploring grain-to-grain contact effects | Dense cubic packing |
| Rapid favorable-condition η estimates | Correlation equations |

---

## Choosing a Platform

| Goal | Recommended platform |
|------|---------------------|
| Learning, visualization, parameter exploration | Matlab GUI (Happel only) |
| Production runs, N > 20 particles | Fortran or Python (parallel via SLURM) |
| Small colloids (AP < 1 µm) | Fortran or Python (parallel via SLURM) |
| Porting / scripting / workflow integration | Python |

---

## Getting Started

New users should begin with the **Happel Matlab GUI**:

1. Watch the [GUI Introduction video](https://youtu.be/tOQ6gz2bI2E)
2. Start with large colloids (AP > 1 µm), high fluid velocity (> 10 m/day),
   and favorable conditions (opposite zeta potentials, SCOV=0, ATTMODE=0)
   for fast familiarization runs
3. Increase realism gradually: add torque balance (ATTMODE=1), then
   heterogeneity (SCOV > 0), then roughness (RMODE > 0)
4. Once familiar with the physics and parameters, move to the Fortran or
   Python codes for production runs

See [`docs/user_manual.md`](../docs/user_manual.md) for full setup and
running instructions, and [`docs/traj_glossary.md`](../docs/traj_glossary.md)
for complete parameter definitions.

---

## Output Files

Each trajectory run produces three flux files — one per outcome category:

| Outcome | ATTACHK code | Meaning |
|---------|-------------|---------|
| Attached | 2, 4, 6 | Colloid arrested at surface |
| Exited | 1 | Colloid left simulation domain |
| Remaining | 3, 5 | Simulation time expired; colloid unresolved |

Trajectory files (step-by-step position and force data) are written only when
NPART < 10, for diagnostic and validation purposes.

See [`docs/traj_attachment.md`](../docs/traj_attachment.md) for a full
description of all outcome codes and zone logic.

---

## References

- Johnson, W.P. and Pazmiño, E.F. (2023). *Colloid (Nano- and Micro-Particle)
  Transport and Surface Interaction in Groundwater*. The Groundwater Project.
  https://doi.org/10.21083/978-1-77470-070-9 — Section 5 (freely available)

- VanNess, K., Rasmuson, A., Ron, C.A., and Johnson, W.P. (2019). A unified
  theory for colloid transport: predicting attachment and mobilization under
  favorable and unfavorable conditions. *Langmuir*, 35(27), 9061–9070.
  https://doi.org/10.1021/acs.langmuir.9b00911

- Rasmuson, A., VanNess, K., Ron, C.A., and Johnson, W.P. (2019).
  Hydrodynamic versus surface interaction impacts of roughness in closing the
  gap between favorable and unfavorable colloid transport conditions.
  *Environmental Science & Technology*, 53(5), 2450–2459.
  https://doi.org/10.1021/acs.est.8b06162

- Ron, C., VanNess, K., Rasmuson, A., and Johnson, W.P. (2019). How nanoscale
  surface heterogeneity impacts transport of nano- to micro-particles on
  surfaces under unfavorable attachment conditions. *Environmental Science:
  Nano*, 6, 1921–1931. https://doi.org/10.1039/C9EN00306A

- Pazmino, E., Trauscht, J., and Johnson, W.P. (2014). Release of colloids
  from primary minimum contact under unfavorable conditions by perturbations
  in ionic strength and flow rate. *Environmental Science & Technology*,
  48(16), 9227–9235. https://doi.org/10.1021/es502503y

Full reference list: [`docs/references.md`](../docs/references.md)
