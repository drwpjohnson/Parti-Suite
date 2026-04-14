# Dense Cubic Packing Trajectory Simulation

Mechanistic Lagrangian trajectory simulation of colloidal particle transport
and deposition in a dense cubic packing unit cell. This stackable geometry
includes grain-to-grain contacts and supports multi-grain trajectory simulation.

---

## What This Code Does

`traj_dcp` (Fortran: `TRAJ-DCP.for`) simulates colloidal particle
trajectories in the flow field of a dense cubic packing unit cell. Unlike the
Happel sphere-in-cell, this geometry includes grain-to-grain contacts and
has a fixed porosity of 0.27. The analytical flow field makes simulations
computationally efficient. Cells can be stacked to explore trajectory
persistence and grain-to-grain transfer across multiple collectors.

**Fixed porosity:** 0.27  
**Grain-to-grain contacts:** yes — stacked simulations supported  
**Represents:** densely packed granular media with grain-to-grain contacts

> ⚠️ **Partial functionality:** Surface heterogeneity (DRNH) is not yet
> implemented in this geometry. Simulations run under uniform surface chemistry
> only. For full heterogeneity support use the Happel or impinging jet codes.

---

## Platform

| Platform | Code | Notes |
|----------|------|-------|
| **Fortran** | `TRAJ-CUBIC.for` | Only available platform |

No Matlab GUI or Python version is currently available. Users new to the
trajectory codes should start with the **Happel Matlab GUI** to learn the
physics and parameter choices before working with this code.

---

## Key Differences from Happel

| Aspect | Dense Cubic Packing | Happel |
|--------|--------------------|----|
| Collector geometry | Spherical grains, dense cubic packing | Single sphere-in-cell |
| Grain-to-grain contacts | Yes | No |
| Stackable | Yes | No |
| Porosity | Fixed (0.27) | Any (set by fluid shell thickness) |
| Heterogeneity (DRNH) | Not implemented | Full support |
| Flow field | Analytical | Analytical |

The dense cubic packing geometry addresses a key limitation of the Happel
geometry — the absence of grain-to-grain contacts — and supports stacked
multi-grain simulations. However, the fixed porosity and lack of heterogeneity
support limit its applicability relative to the Happel code for most
environmental colloid transport problems.

---

## Quick Start

```bash
# Compile
ifort -O2 -o traj_dcp.o TRAJ-DCP.for

# Copy and edit the input file
cp inputs/INPUT.IN my_run/INPUT.IN

# Run
cd my_run/
../traj_dcp.o
```

---

## Output Files

**Serial mode (CLUSTER=0):** output files are named by cell number:

| File | Outcome | ATTACHK codes |
|------|---------|---------------|
| `FLUXATT{CELL}.OUT` | Attached | 2, 4, 6 |
| `FLUXREM{CELL}.OUT` | Remaining (time expired) | 3, 5 |
| `FLUXEX{CELL}.OUT` | Exited domain | 1 |

**Parallel mode (CLUSTER=1):** per-particle files use the Happel naming
convention (`HAPHETFLUXATT.N.OUT` etc.) and are concatenated after all
workers finish.

Output format and column definitions are identical to the Happel flux files —
see [`docs/traj_attachment.md`](../../../docs/traj_attachment.md).

---

## References

- Johnson, W.P. and Pazmiño, E.F. (2023). *Colloid (Nano- and Micro-Particle)
  Transport and Surface Interaction in Groundwater*. The Groundwater Project.
  https://doi.org/10.21083/978-1-77470-070-9 (freely available)

- Johnson, W.P., Li, X., and Yal, G. (2007). Colloid retention in porous
  media: mechanistic confirmation of wedging and retention in zones of flow
  stagnation. *Environmental Science & Technology*, 41, 1279–1287.
  https://doi.org/10.1021/es061301x

Full reference list: [`docs/references.md`](../../../docs/references.md)
