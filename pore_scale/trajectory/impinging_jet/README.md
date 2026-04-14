# Impinging Jet Trajectory Simulation

Mechanistic Lagrangian trajectory simulation of colloidal particle transport
and deposition in the impinging jet collector geometry. Directly comparable
to laboratory radial stagnation-flow deposition cell experiments.

---

## What This Code Does

`traj_jet` simulates colloidal particle trajectories in the flow field of a
radial stagnation-point impinging jet directed at a flat collector plate. The
flow field is described by a rational polynomial approximation (VanNess et al.,
2019) that is computationally inexpensive — making this the fastest trajectory
geometry per timestep in Parti-Suite.

**Separation distance:** H = Z − AP (height above plate minus colloid radius)

**Represents:** laboratory radial stagnation-flow deposition cells; impinging
jet direct observation experiments on a single focal plane

The physics — forces, attachment criteria, heterodomain system, and
infrastructure — are identical to the Happel code. Only the flow field,
collector geometry, and coordinate system differ.

---

## Platforms

| Platform | Code | Best for |
|----------|------|----------|
| **Fortran** | `TRAJ-JET.for` | Production runs, large populations, maximum speed |
| **Python** | `traj_jet.py` | Production runs, parallelization via SLURM, scripting |

No Matlab GUI is available for this geometry. Users new to the trajectory codes
should start with the **Happel Matlab GUI** to learn the physics and parameter
choices, then apply that knowledge here.

---

## Key Differences from Happel

| Aspect | Impinging Jet | Happel |
|--------|--------------|--------|
| Collector geometry | Flat plate | Sphere (radius AG) |
| Flow field | Rational polynomial (`jet_ff`) | Analytic Stokes (`happel_ff`) |
| EDL/VdW geometry | Sphere-plate | Sphere-sphere |
| VdW effective radius | AP | AEFF = AP·AG/(AP+AG) |
| Normal direction | Vertical (Z axis) | Radial from collector centre |
| Separation H | Z − AP | R − AG − AP |
| Gravity | Scalar, Z-axis only; GRAVFACT=−1 (with flow) | Full 3D decomposition; CBGRAV parameter |
| Near-surface threshold | Hardwired 2×10⁻⁷ m | Read from input (HNS) |
| Exit condition | R > REXIT | R > RB |
| Speed per timestep | Faster | Slower |
| Unique parameters | VJET, REXIT, RJET, ZMAX | AG, POROSITY, VSUP, CBGRAV, HNS |

The impinging jet geometry focuses on the forward stagnation zone and is
directly comparable to impinging jet direct observation experiments. Unlike
the Happel geometry, it represents a fixed-porosity flat-collector system
rather than a granular porous medium.

---

## Quick Start

### Serial test run (Python)

```bash
cd pore_scale/trajectory/impinging_jet/python/

# Copy and edit the input file
cp inputs/INPUT_jet.IN my_run/INPUT_jet.IN
# edit my_run/INPUT_jet.IN with your parameters

# Run a single test particle (NPART=1, CLUSTER=0)
cd my_run/
python3 ../traj_jet.py
```

### Parallel production run (Python, SLURM)

```bash
# Set CLUSTER=1 in INPUT_jet.IN
sbatch job_slurm_jet
```

### Fortran

```bash
# Compile
ifort -O2 -o traj_jet.o TRAJ-JET.for

# Edit INPUT.IN, then run
./traj_jet.o
```

See [`docs/user_manual.md`](../../../docs/user_manual.md) for full setup
and cluster configuration instructions.

---

## Input File

The input file (`INPUT_jet.IN`) follows the same format as `INPUT_hap.IN`.
Parameters shared with the Happel code use identical names. Jet-specific
parameters:

| Parameter | Meaning | Notes |
|-----------|---------|-------|
| `VJET` | Jet velocity (m/s) | Scales the entire flow field |
| `REXIT` | Radial exit boundary (m) | Typically ≈ AG; colloids beyond this exit |
| `RJET` | Jet nozzle radius (m) | Defines flow field geometry |
| `ZMAX` | Initial injection height (m) | Height above plate where particles start |
| `GRAVFACT` | Gravity direction | −1.0 = with flow (downward); +1.0 = against flow |

All other parameters (AP, IS, ZETAPST, ZETACST, SCOV, ATTMODE, NPART, TTIME,
MULTB, MULTNS, MULTC, etc.) are identical to the Happel input file.

Full parameter definitions: [`docs/traj_glossary.md`](../../../docs/traj_glossary.md)

---

## Output Files

| File | Outcome | ATTACHK codes |
|------|---------|---------------|
| `JETFLUXATT.OUT` | Attached | 2, 4, 6 |
| `JETFLUXREM.OUT` | Remaining (time expired) | 3, 5 |
| `JETFLUXEX.OUT` | Exited domain | 1 |

In parallel mode (CLUSTER=1), per-particle files (`JETFLUXATT.N.OUT` etc.)
are written and concatenated after all workers finish.

Trajectory files are written only when NPART < 10.

Output format and column definitions are identical to the Happel flux files —
see [`docs/traj_attachment.md`](../../../docs/traj_attachment.md).

---

## Parallel Computing

The Python parallel infrastructure is identical to the Happel code:

```
python/
  traj_jet.py          Main trajectory code
  jet.csh              Orchestration script — builds job list, submits workers
  job_slurm_jet        SLURM submission script
  inputs/
    INPUT_jet.IN       Template input file
```

The same cluster configuration rules apply — always hardcode the full path
to python3 in the job list. See the Happel README for full parallel
infrastructure details.

---

## Performance

The impinging jet geometry is faster per timestep than the Happel geometry due
to its simpler polynomial flow field and planar geometry. For the same colloid
and conditions, expect substantially shorter wall-clock times per particle.

Timestep guidance by colloid size is the same as for Happel — see
[`docs/user_manual.md`](../../../docs/user_manual.md) Section 9.

---

## Validation

The Python code (`traj_jet.py`) has been validated against the Fortran binary
(`TRAJ-JET.for`) with step-by-step trajectory comparison at DIFFSCALE=0.
Agreement across all simulation zones is equivalent to the Happel validation —
see the Happel README for the validation table. Both codes reproduce the same
physical outcome (ATTACHK code, attachment location) as the Fortran reference.

---

## References

- Johnson, W.P. and Pazmiño, E.F. (2023). *Colloid (Nano- and Micro-Particle)
  Transport and Surface Interaction in Groundwater*. The Groundwater Project.
  https://doi.org/10.21083/978-1-77470-070-9 (freely available)

- VanNess, K., Rasmuson, A., Ron, C.A., and Johnson, W.P. (2019). A unified
  theory for colloid transport: predicting attachment and mobilization under
  favorable and unfavorable conditions. *Langmuir*, 35(27), 9061–9070.
  https://doi.org/10.1021/acs.langmuir.9b00911

- Pazmino, E., Trauscht, J., and Johnson, W.P. (2014). Release of colloids
  from primary minimum contact under unfavorable conditions by perturbations
  in ionic strength and flow rate. *Environmental Science & Technology*,
  48(16), 9227–9235. https://doi.org/10.1021/es502503y

Full reference list: [`docs/references.md`](../../../docs/references.md)
