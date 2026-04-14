# Nano Scale — Colloid-Surface Interactions

This module provides tools for calculating nanoscale interactions between
colloidal particles and grain surfaces. These interactions govern whether a
colloid that contacts a surface will attach or be repelled, and are the
foundation for understanding colloid transport under both favorable and
unfavorable attachment conditions.

---

## Background

The transport and fate of colloids in granular porous media is ultimately
governed by nanoscale surface forces acting between colloid and grain surfaces
at separation distances of less than ~200 nm. These forces are described by
extended DLVO (xDLVO) theory, which superimposes the following interactions:

| Interaction | Range | Notes |
|-------------|-------|-------|
| **Van der Waals (VDW)** | Up to ~200 nm | Electrodynamic and dipole interactions; always attractive between like materials in water |
| **Electric double layer (EDL)** | Up to ~50 nm | Electroosmotic interactions between counterion clouds on each surface; repulsive for like-charged surfaces, attractive for opposite-charged |
| **Lewis acid-base (LAB)** | Several nm | Short-range hydrophobic/hydrophilic interactions |
| **Steric/hydration** | Several nm | Repulsion from polymer coatings or hydration layers |
| **Born repulsion** | ~0.16 nm | Electron orbital overlap at contact; defines equilibrium separation distance |

The magnitude of the surface charge on colloids and grains is characterized by
the zeta potential (ζ, in volts), which is measured experimentally. In
groundwater, both colloid and grain surfaces are typically negatively charged,
creating a repulsive barrier to attachment — so-called **unfavorable
conditions**. Attachment under unfavorable conditions occurs via nanoscale
zones of opposite charge on grain surfaces called **heterodomains**.

### Favorable vs. Unfavorable Conditions

**Favorable conditions** (opposite-charged surfaces): the superimposed xDLVO
profile shows a deep primary minimum at contact — VDW and EDL interactions are
both attractive at close range, and no repulsive barrier exists. Colloids that
reach the surface attach readily.

**Unfavorable conditions** (like-charged surfaces): the xDLVO profile shows a
repulsive energy barrier between a shallow primary minimum at contact and a
weakly attractive secondary minimum at larger separation distances (~10–100 nm
depending on ionic strength). The height of the repulsive barrier decreases and
the depth of the secondary minimum increases with increasing ionic strength (IS)
and decreasing pH.

### Zone of Colloid-Surface Interaction (ZOI)

Because xDLVO interactions decay rapidly with separation distance, they act
only over a finite zone of interaction (ZOI) on the grain surface — a circular
area centered at the point of closest approach. The ZOI radius scales as:

- **EDL**: a_ZOI = 2√(κ⁻¹ · a_p)  where κ⁻¹ is the Debye length and a_p is colloid radius
- **LAB**: a_ZOI = 2√(λ_AB · a_p)  where λ_AB is the LAB decay length

The ZOI shrinks with increasing IS (shorter Debye length) and with decreasing
colloid size. This has two important consequences:

1. A heterodomain of given size occupies a larger fraction of the ZOI as
   colloid size decreases — a surface that is net repulsive for a large colloid
   may be net attractive for a smaller one.
2. Increasing IS contracts the ZOI, potentially increasing the fractional
   overlap with a heterodomain and flipping net repulsion to net attraction —
   the mechanistic basis for IS-driven attachment and detachment.

### Surface Roughness

Surface roughness reduces all xDLVO interactions — both repulsive and
attractive — by reducing the effective radius of curvature at the point of
contact. Roughness does not flip repulsive interactions to attractive, but it
does reduce the repulsive barrier height, facilitating attachment under
unfavorable conditions. Parti-Suite represents roughness via asperity height
parameters that enter both the surface interaction expressions and the
hydrodynamic lubrication corrections in the trajectory codes.

---

## Modules

### `xdlvo/` — Extended DLVO Interaction Calculator

Calculates colloid-surface interaction energy and force profiles as a function
of separation distance. Implements VDW (retarded, with optional coating
layers), EDL (Poisson-Boltzmann, linear superposition), LAB, steric, and Born
interactions for sphere-plate and sphere-sphere geometries.

**Platforms:** Excel, Matlab, Python

**Key capabilities:**
- Sphere-plate and sphere-sphere geometries
- Layered (coated) and non-layered colloids and collectors (4 VDW modes)
- Smooth and rough surfaces
- Nanoscale heterodomain centered on ZOI — demonstrates transition from net
  repulsive to net attractive as heterodomain size or IS increases
- Calculates Hamaker constants from permittivity and refractive index values,
  or accepts user-supplied values

The xDLVO and trajectory codes are designed to work together — xDLVO output
informs selection of surface interaction parameters (A₁₃₂, ζ potentials,
LAB parameters, steric parameters) for use in the trajectory simulations.

📺 Video: [xDLVO module walkthrough](https://youtu.be/rnKLHnE-vBo)

See [`xdlvo/README.md`](xdlvo/README.md) for input parameters, usage, and examples.

---

### `afm_force_volume/` — AFM Colloidal Probe Force-Volume Simulation

Simulates AFM colloidal probe force-volume measurements over a surface with
user-specified heterodomain size and surface coverage. The code calculates
xDLVO interactions at a user-defined raster grid of probe locations, where
each probe location may or may not overlap with heterodomains depending on
their size, coverage, and arrangement.

**Platforms:** Matlab, Python

**Key capabilities:**
- User-specified heterodomain radius, surface coverage, and raster spacing
- Calculates ZOI radius for each probe location
- Determines fractional ZOI overlap with heterodomains at each raster point
- Produces adhesion force maps and histograms that reproduce the variance
  observed in experimental AFM force-volume measurements
- Demonstrates how raster spacing interacts with heterodomain size to produce
  variance in measured adhesion forces

The variance in simulated adhesion forces arises from variance in the degree
of ZOI overlap with heterodomains across the raster grid — the same mechanism
that drives colloid-by-colloid variability in attachment in the trajectory
codes.

See [`afm_force_volume/README.md`](afm_force_volume/README.md) for input
parameters, usage, and examples.

---

## References

The theoretical basis for the xDLVO interactions implemented in this module
is described in:

- Johnson, W.P. and Pazmiño, E.F. (2023). *Colloid (Nano- and Micro-Particle)
  Transport and Surface Interaction in Groundwater*. The Groundwater Project.
  https://doi.org/10.21083/978-1-77470-070-9 — Section 4 (freely available)

- Elimelech, M. and O'Melia, C.R. (1990). Kinetics of deposition of colloidal
  particles in porous media. *Environmental Science & Technology*, 24(10),
  1528–1536.

- Pazmino, E., Trauscht, J., and Johnson, W.P. (2014). Release of colloids
  from primary minimum contact under unfavorable conditions by perturbations
  in ionic strength and flow rate. *Environmental Science & Technology*,
  48(16), 9227–9235. https://doi.org/10.1021/es502503y

- Ron, C., VanNess, K., Rasmuson, A., and Johnson, W.P. (2019). How nanoscale
  surface heterogeneity impacts transport of nano- to micro-particles on
  surfaces under unfavorable attachment conditions. *Environmental Science:
  Nano*, 6, 1921–1931. https://doi.org/10.1039/C9EN00306A

- Ron, C. and Johnson, W.P. (2020). Relating xDLVO and AFM measurements to
  colloid transport in porous media. *Langmuir*.

Full reference list: [`docs/references.md`](../docs/references.md)
