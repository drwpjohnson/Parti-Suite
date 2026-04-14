# Happel Sphere-in-Cell Trajectory Simulation

Mechanistic Lagrangian trajectory simulation of colloidal particle transport
and deposition in the Happel sphere-in-cell collector geometry. This is the
most thoroughly documented and validated geometry in Parti-Suite and the
recommended starting point for new users.

---

## What This Code Does

`traj_hap` simulates the trajectories of colloidal particles (submicron to
micron-scale spheres) moving through the flow field around a spherical collector
grain in a Happel sphere-in-cell geometry. At each timestep, all relevant
forces are computed and integrated forward in time until the particle attaches,
exits the simulation domain, or the simulation time limit is reached.

The Happel geometry represents a spherical collector grain of radius AG
surrounded by a concentric fluid shell whose outer radius RB is set by the
bed porosity. Flow is Stokes (creeping) flow described by an analytical
stream function, making this geometry computationally efficient and applicable
to any porosity.

**Separation distance:** H = R − AG − AP (distance from grain surface to
colloid center, minus colloid radius)

**Represents:** packed-bed columns, granular filters, subsurface porous media

---

## Platforms

Three implementations are available, suited to different use cases:

| Platform | Code | Best for |
|----------|------|----------|
| **Matlab (GUI)** | `Traj-Hap` | Learning, visualization, parameter exploration, populations of tens to hundreds of particles |
| **Fortran** | `TRAJ-HAP.for` | Production runs, large populations (hundreds to thousands), maximum speed |
| **Python** | `traj_hap.py` | Production runs, easy parallelization via SLURM, scripting and workflow integration |

The Matlab GUI is the recommended starting point — it provides real-time
visualization of 3D trajectories, force panels, and near-surface diagnostics
as the simulation runs, making it invaluable for learning the physics and
checking parameter choices. The Fortran and Python codes are recommended for
production runs once the user is familiar with the physics and input parameters.

📺 Videos (Matlab GUI):
- [GUI Introduction](https://youtu.be/tOQ6gz2bI2E)
- [Favorable conditions](https://youtu.be/kDuP98YLFow)
- [Collector efficiencies](https://youtu.be/UBFmm3_hjm4)
- [Unfavorable conditions](https://youtu.be/iONHPUl8mkM)
- [Perturbation/detachment](https://youtu.be/GjOIg4Fb-_I)

---

## Physics

All three platforms implement identical physics:

- **Hydrodynamic drag** — Goldman-Cox-Brenner lubrication corrections for
  normal and tangential motion near the grain surface
- **Brownian diffusion** — Langevin stochastic force
- **Van der Waals attraction** — retarded, with optional coating layers
  (4 modes: uncoated, both coated, collector coated only, colloid coated only)
- **Electrostatic double-layer** — sphere-sphere geometry
- **Lewis acid-base and steric repulsion**
- **Born contact repulsion**
- **Gravity** — full normal/tangential vector decomposition; direction set by
  CBGRAV (1 = with flow, 2 = against, 3 and 4 = orthogonal)
- **Lift**
- **JKR contact mechanics** — elastic deformation and torque-balance attachment

Surface chemical heterogeneity (DRNH) is supported on both collector (SCOV)
and colloid (SCOVP) surfaces via a tiled heterodomain system. Collector and
colloid roughness are supported via asperity height parameters (ASP, ASP2, B).

---

## Quick Start

### Matlab GUI

1. Install Matlab Runtime (if using the compiled executable)
2. Run as Administrator (Windows: right-click → Run as administrator)
3. The command window opens first, followed by the GUI — allow a few minutes
   for the GUI to load
4. Start with the default parameters to familiarize yourself with the outputs,
   then modify parameters for your system
5. For first runs: use large colloids (AP > 1 µm), high velocity (> 10 m/day),
   favorable conditions (opposite zeta potentials), ATTMODE=0, NPART=5

### Python (serial test run)

```bash
# Clone the repository
git clone https://github.com/drwpjohnson/parti-suite.git
cd parti-suite/pore_scale/trajectory/happel/python/

# Copy and edit the input file
cp inputs/INPUT_hap.IN my_run/INPUT_hap.IN
# edit my_run/INPUT_hap.IN with your parameters

# Run a single test particle
cd my_run/
python3 ../traj_hap.py     # set NPART=1, CLUSTER=0 in INPUT_hap.IN
```

### Python (parallel production run via SLURM)

```bash
# Set CLUSTER=1 in INPUT_hap.IN
sbatch job_slurm_hap
```

See [`docs/user_manual.md`](../../../docs/user_manual.md) for full setup
instructions including cluster configuration.

### Fortran

```bash
# Compile (if building from source)
ifort -O2 -o haphet.o TRAJ-HAP.for

# Edit INPUT.IN with your parameters
# Run
./haphet.o
```

---

## Input File

Each platform reads a plain-text input file (`INPUT_hap.IN` for Python/Matlab,
`INPUT.IN` for Fortran). Lines whose first token is not a number are treated as
comments and ignored. Data lines are read in strict order — do not reorder them.

### Key parameters to set first

| Parameter | Meaning | Notes |
|-----------|---------|-------|
| `AP` | Colloid radius (m) | Everything scales from this |
| `AG` | Grain radius (m) | Sets Happel cell size |
| `POROSITY` | Bed porosity | Sets outer fluid shell radius RB |
| `VSUP` | Superficial fluid velocity (m/s) | Scales entire flow field |
| `ZETAPST` | Colloid zeta potential (V) | Opposite sign to ZETACST → favorable |
| `ZETACST` | Collector zeta potential (V) | Same sign as ZETAPST → unfavorable |
| `IS` | Ionic strength (mol/m³) | Controls EDL decay length |
| `ATTMODE` | 0 = perfect sink; 1 = torque balance | Start with 0 |
| `NPART` | Number of particles | 1–5 for testing; 100+ for production |
| `CLUSTER` | 0 = serial; 1 = parallel | Use 0 for testing |
| `TTIME` | Max simulation time per particle (s) | Increase if ATTACHK=3 dominates |
| `CBGRAV` | Gravity direction (1–4) | 1 = with flow (−Z) |

Full parameter definitions with units, typical values, and physical meaning:
[`docs/traj_glossary.md`](../../../docs/traj_glossary.md)

---

## Output Files

Each run produces three flux files:

| File | Outcome | ATTACHK codes |
|------|---------|---------------|
| `HAPHETFLUXATT.OUT` | Attached | 2, 4, 6 |
| `HAPHETFLUXREM.OUT` | Remaining (time expired) | 3, 5 |
| `HAPHETFLUXEX.OUT` | Exited domain | 1 |

In parallel mode (CLUSTER=1), per-particle files (`HAPHETFLUXATT.N.OUT` etc.)
are written and concatenated by the orchestration script after all workers
finish.

Trajectory files (`HAPHETtrajatt.OUT` etc.) are written only when NPART < 10,
for diagnostic and validation purposes.

Each flux file contains a 4-line parameter header followed by one data row per
particle. Key output columns include: initial and final position (XINIT, YINIT,
ZINIT, XOUT, YOUT, ZOUT), separation distance (HINIT, HOUT), elapsed time
(ETIME, TBULK, TNEAR, TFRIC), outcome code (ATTACHK), and heterodomain overlap
fraction (AFRACT).

For a full description of all output columns and outcome codes:
[`docs/traj_attachment.md`](../../../docs/traj_attachment.md)

---

## Parallel Computing (Python and Fortran)

Both the Python and Fortran codes support parallelized simulation via SLURM,
where each worker process handles a single particle trajectory independently.
This eliminates file write conflicts and scales efficiently to large particle
populations.

### Python parallel infrastructure

```
python/
  traj_hap.py          Main trajectory code
  hap.csh              Orchestration script — builds job list, submits workers
  job_slurm_hap        SLURM submission script
  job_slurm_hap_compare  Single-particle comparison script (bypasses submit,
                         passes XINIT/YINIT for validation runs)
  inputs/
    INPUT_hap.IN       Template input file
```

**Important:** The `submit` MPI dispatcher passes at most 5 space-separated
tokens per worker. Use `job_slurm_hap_compare` for validation runs that need
to pass XINIT/YINIT — this calls Python directly from the SLURM script,
bypassing the argument limit. Production runs are unaffected.

**Python path:** Always hardcode the full path to python3 in the job list
(e.g., `/usr/bin/python3`). A wrong path causes all particles to exit in
~0.007s with ATTACHK=1. Confirm with `which python3` on your cluster.

---

## Performance

Run time is dominated by the near-surface zone. Key guidance:

| Colloid size (AP) | Recommended MULTNS | Notes |
|-------------------|--------------------|-------|
| ≥ 2 µm | 2–10 | Fast — suitable for serial runs |
| 1 µm | 10–20 | Moderate |
| 500 nm | 20–25 | Slow — use parallel |
| < 500 nm | 25–50 | Very slow — always use parallel |

The Happel geometry is slower per timestep than the impinging jet geometry due
to the analytic Happel flow field, 3D vector gravity decomposition, and
quaternion heterodomain geometry. For complex runs (SCOV > 0, SCOVP > 0,
RMODE > 0), always submit as a batch job.

---

## Validation

The Python code (`traj_hap.py`) has been validated against the Fortran binary
(`TRAJ-HAP.for`) with step-by-step trajectory comparison at DIFFSCALE=0.
Agreement across all simulation zones:

| Zone | Variable | Agreement |
|------|----------|-----------|
| Bulk | H, UN, VN | < 0.001% |
| Near-surface | H | < 0.1% |
| Near-surface | AFRACT | < 0.6% typical |
| Contact | H at attachment | < 0.3% |
| Contact | ACONT | < 0.2% |
| Final outcome | Location, ETIME | < 0.1% |

Both codes reproduce the same physical outcome (ATTACHK code, attachment
location) as the Fortran reference for all validated test cases.

---

## Rod-Shaped Colloids

An extension of the Happel trajectory code for rod-shaped colloids with
explicit rotational dynamics is available in
[`happel/rod_shaped/`](rod_shaped/). This Fortran code was developed by
Ke Li and Huilian Ma and requires explicit calculation of colloid rotation
in the flow field.

---

## Documentation

| Document | Contents |
|----------|----------|
| [User Manual](../../../docs/user_manual.md) | Setup, running, monitoring, interpreting results, troubleshooting |
| [Parameter Glossary](../../../docs/traj_glossary.md) | Every input parameter defined with units and typical values |
| [Attachment Criteria](../../../docs/traj_attachment.md) | Outcome codes, zone logic, slow-motion criteria |
| [Trajectory Flowchart](https://drwpjohnson.github.io/Parti-Suite/docs/traj_flowchart.html) | Visual overview of the trajectory loop (open in browser) |

---

## References

- Johnson, W.P. and Pazmiño, E.F. (2023). *Colloid (Nano- and Micro-Particle)
  Transport and Surface Interaction in Groundwater*. The Groundwater Project.
  https://doi.org/10.21083/978-1-77470-070-9 (freely available)

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

Full reference list: [`docs/references.md`](../../../docs/references.md)
