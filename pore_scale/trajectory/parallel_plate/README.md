# Parallel Plate Trajectory Simulation

Mechanistic Lagrangian trajectory simulation of colloidal particle transport
and deposition in a parallel plate collector geometry. Directly comparable to
parallel plate direct observation experiments and appropriate for systems where
colloid delivery to surfaces is dominated by diffusion and/or gravity rather
than flow impingement.

---

## What This Code Does

`traj_plate` (Fortran: `TRAJ-PAR.for`) simulates colloidal particle trajectories
in the flow field between two parallel plates, where one plate acts as the
collector surface. The flow field is Poiseuille (channel) flow. Unlike the
Happel and impinging jet geometries, which focus on forward stagnation zones,
the parallel plate geometry is dominated by longitudinal transport, making it
particularly appropriate for studying gravity-driven deposition and systems
analogous to fractures or pore channels.

**Represents:** parallel plate direct observation experiments; fracture flow
systems; systems where delivery to surfaces is dominated by diffusion and/or
gravity rather than flow impingement

The physics — forces, attachment criteria, and heterodomain system — are
identical to the Happel and impinging jet codes.

---

## Platform

| Platform | Code | Notes |
|----------|------|-------|
| **Fortran** | `TRAJ-PAR.for` | Only available platform |

No Matlab GUI or Python version is currently available. Users new to the
trajectory codes should start with the **Happel Matlab GUI** to learn the
physics and parameter choices before working with this code.

---

## Key Differences from Happel

| Aspect | Parallel Plate | Happel |
|--------|---------------|--------|
| Collector geometry | Flat plate | Sphere (radius AG) |
| Flow field | Poiseuille (channel) flow | Analytic Stokes sphere-in-cell |
| EDL/VdW geometry | Sphere-plate | Sphere-sphere |
| Delivery mechanism | Diffusion and gravity dominant | Flow impingement dominant |
| Represents | Fractures, plate experiments | Granular packed beds |

---

## Quick Start

```bash
# Compile
ifort -O2 -o traj_par.o TRAJ-PAR.for

# Copy and edit the input file
cp inputs/INPUT_par.IN my_run/INPUT_par.IN

# Run
cd my_run/
../traj_par.o
```

See [`docs/user_manual.md`](../../../docs/user_manual.md) for full parameter
descriptions and guidance.

---

## Output Files

| File | Outcome | ATTACHK codes |
|------|---------|---------------|
| `PLATEFLUXATT.OUT` | Attached | 2, 4, 6 |
| `PLATEFLUXREM.OUT` | Remaining (time expired) | 3, 5 |
| `PLATEFLUXEX.OUT` | Exited domain | 1 |

Output format and column definitions are identical to the Happel and impinging
jet flux files — see [`docs/traj_attachment.md`](../../../docs/traj_attachment.md).

---

## References

- Johnson, W.P. and Pazmiño, E.F. (2023). *Colloid (Nano- and Micro-Particle)
  Transport and Surface Interaction in Groundwater*. The Groundwater Project.
  https://doi.org/10.21083/978-1-77470-070-9 (freely available)

- Rasmuson, A., VanNess, K., Ron, C.A., and Johnson, W.P. (2019).
  Hydrodynamic versus surface interaction impacts of roughness in closing the
  gap between favorable and unfavorable colloid transport conditions.
  *Environmental Science & Technology*, 53(5), 2450–2459.
  https://doi.org/10.1021/acs.est.8b06162

Full reference list: [`docs/references.md`](../../../docs/references.md)
