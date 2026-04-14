# User Manual: Colloid Trajectory Simulation Codes
### traj_hap.py · traj_jet.py · TRAJ-HAP.for · TRAJ-JET.for · TRAJ-PAR.for · TRAJ-DCP.for

---

## Contents

1. [What these codes do](#1-what-these-codes-do)
2. [Choosing between traj_jet and traj_hap](#2-choosing-between-traj_jet-and-traj_hap)
3. [Before you run: understanding the input file](#3-before-you-run-understanding-the-input-file)
4. [Setting up a simulation](#4-setting-up-a-simulation)
5. [Running the simulation](#5-running-the-simulation)
6. [Monitoring a run in progress](#6-monitoring-a-run-in-progress)
7. [Understanding your results](#7-understanding-your-results)
8. [Choosing your physics settings](#8-choosing-your-physics-settings)
9. [Performance: how long will it take?](#9-performance-how-long-will-it-take)
10. [Troubleshooting](#10-troubleshooting)
11. [Quick-reference parameter tables](#11-quick-reference-parameter-tables)

---

## 1. What these codes do

`traj_jet.py` and `traj_hap.py` simulate the trajectories of colloidal particles
(submicron to micron-scale spheres) moving through a fluid toward a collector surface.
At each timestep the codes calculate all relevant physical forces acting on each
particle — hydrodynamic drag, Brownian diffusion, van der Waals attraction, electrostatic
double-layer repulsion or attraction, gravity, lift, and short-range contact forces —
and integrate the particle's motion forward in time until it either attaches to the
collector, exits the simulation domain, or the simulation time limit is reached.

The end result for each particle is a single **outcome code** (ATTACHK) and a row of
flux data describing where it ended up, how long it took, and the surface chemistry
conditions at the moment of attachment or departure. Run enough particles and the
distribution of outcomes gives you attachment efficiency, the role of surface
heterogeneity, and the influence of flow conditions on colloid transport.

The two codes are physically identical. They differ only in collector geometry and
flow field — see Section 2.

---

## 2. Choosing between traj_jet and traj_hap

| Question | traj_jet.py | traj_hap.py |
|----------|-------------|-------------|
| What geometry? | Flat collector plate, impinging jet flow | Spherical collector grain, Happel sphere-in-cell flow |
| What system does this represent? | Radial stagnation-flow deposition cell (laboratory) | Packed-bed column or granular filter |
| Where does the particle start? | At height ZMAX above the plate, within radius RLIM of the jet axis | At the outer fluid-cell boundary RB, within radius RLIM of the forward stagnation axis |
| What is the collector? | A flat surface | A sphere of radius AG |
| Separation distance H | H = Z − AP (height above plate minus colloid radius) | H = R − AG − AP (distance from grain surface) |
| Faster to run? | Yes — simpler geometry, cheaper per timestep | No — analytic flow field and 3D geometry cost more per step |
| Input file | `INPUT_jet.IN` | `INPUT_hap.IN` |
| Output files | `JETFLUX*.OUT` | `HAPHETFLUX*.OUT` |

**Use `traj_jet.py`** if you are modelling a laboratory impinging-jet deposition
experiment, or if you want faster runs to explore parameter space.

**Use `traj_hap.py`** if you are modelling colloid transport in a granular porous
medium (e.g. sand filtration, subsurface transport), or need the sphere-in-cell
geometry for comparison with column experiments.

Both codes produce the same flux output format and use identical input parameter
names wherever the physics is shared.

---

## 3. Before you run: understanding the input file

Each code reads a plain-text input file — `INPUT_jet.IN` or `INPUT_hap.IN`.
Lines beginning with text are comments and are ignored. Only lines whose first
token is a number are read as data, in strict order. **Do not reorder the data
lines or remove comment lines between them.**

The input file is divided into 15 groups of parameters. The table below gives
a plain-language summary of each group. Full parameter definitions are in the
[glossary](traj_glossary.md).

| Group | What it controls |
|-------|-----------------|
| 1 | How many particles, attachment mode, serial vs parallel |
| 2 | Flow velocity, collector size, injection radius, simulation time limit |
| 3 | Colloid size, density, fluid viscosity and permittivity |
| 4 | Ionic strength, electrolyte valence, zeta potentials |
| 5 | Collector surface heterodomains (charge patches) |
| 6 | Colloid surface heterodomains |
| 7 | Van der Waals force parameters |
| 8 | Lewis acid-base and steric repulsion |
| 9 | Surface roughness (asperities, slip length) |
| 10 | JKR contact mechanics (elastic deformation, work of adhesion) |
| 11 | Diffusion and gravity multipliers |
| 12 | Timestep multipliers and slow-motion thresholds |
| 13 | Output frequency (trajectory snapshots) |

### The most important parameters to get right first

Before worrying about surface chemistry details, make sure these are correct:

**AP** — colloid radius (m). Everything else scales from this. A factor-of-2
error here changes run times by 4× and forces by orders of magnitude.

**ZETAPST / ZETACST** — zeta potentials of colloid and collector (V).
Opposite signs → favorable (attractive) conditions. Same sign → unfavorable
(repulsive) — attachment only occurs via heterodomains. This is the most common
source of unexpected results.

**ATTMODE** — 0 for perfect sink (every particle that touches the surface
attaches), 1 for torque-balance (physically realistic). Start with ATTMODE=0 to
confirm particles are reaching the surface before adding attachment mechanics.

**TTIME** — maximum simulation time per particle (s). If most particles come
back as ATTACHK=3 (remaining), TTIME is too short.

**NPART** — number of particles. Use 1–5 for a first diagnostic run, then
scale up to 100+ for production statistics.

---

## 4. Setting up a simulation

### Step 1 — Copy an existing input file

Start from the validated template in the repository:

```
pore_scale/trajectory/impinging_jet/python/inputs/INPUT_jet.IN    (jet)
pore_scale/trajectory/happel/python/inputs/INPUT_hap.IN           (hap)
```

Copy it to your own run directory and edit the parameter values. Never edit
the template directly.

### Step 2 — Set your physical system

Edit the following parameter groups for your experiment:

**Colloid and fluid (Group 3)**

```
AP      colloid radius in metres         e.g.  2.2e-6   (2.2 µm)
RHOP    colloid density (kg/m³)          e.g.  1050
RHOW    fluid density (kg/m³)            e.g.  998
VISC    dynamic viscosity (kg/m·s)       e.g.  9.98e-4
ER      relative permittivity            e.g.  80       (water)
T       temperature (K)                  e.g.  298
```

**Water chemistry (Group 4)**

```
IS      ionic strength (mol/m³)          e.g.  6.0
ZI      electrolyte valence              e.g.  1.0
ZETAPST colloid zeta potential (V)       e.g. -0.046    (negative)
ZETACST collector zeta potential (V)     e.g.  0.055    (positive → favorable)
```

**Flow and geometry (Group 2)** — see the code-specific notes below.

*For traj_hap:*
```
VSUP    superficial velocity (m/s)       e.g.  1.0e-4
AG      grain radius (m)                 e.g.  2.0e-4
POROSITY bed porosity                    e.g.  0.38
RLIM    injection radius (m)             e.g.  AG/5     (e.g. 4e-5)
TTIME   max simulation time (s)          e.g.  5000
CBGRAV  gravity direction (1–4)          e.g.  1        (with flow, −Z)
```

*For traj_jet:*
```
VJET    jet velocity (m/s)               e.g.  1.0e-3
AG      collector radius (m)             e.g.  2.5e-4
REXIT   radial exit boundary (m)         e.g.  2.5e-4   (≈ AG)
RLIM    injection radius (m)             e.g.  5.0e-6
TTIME   max simulation time (s)          e.g.  5000
```

### Step 3 — Set surface chemistry and heterogeneity

If your surfaces are chemically uniform (no charge patches):
```
SCOV  = 0     (no collector heterodomains)
SCOVP = 0     (no colloid heterodomains)
HETMODE  = 1
HETMODEP = 1
```

If you want to model charge-heterogeneous surfaces:
```
SCOV     fractional coverage of collector patches  e.g. 0.001
ZETAHET  zeta potential of collector patches (V)   e.g. 0.055 (attractive)
HETMODE  1 = uniform size;  9 = bimodal (1 large + 8 medium)
RHET0    large patch radius (m)                    e.g. 1.0e-7
RHET1    medium patch radius (m, HETMODE=9 only)   e.g. 5.0e-8

SCOVP    fractional coverage of colloid patches    e.g. 0.39
ZETAHETP zeta potential of colloid patches (V)     e.g. 0.055
HETMODEP 1 or 9
RHETP0   large colloid patch radius (m)            e.g. 5.0e-8
```

> **Note**: HETMODE=5 and HETMODE=73 are not supported. Use only HETMODE=1 or 9.

### Step 4 — Set timestep multipliers (Group 12)

These control simulation speed and accuracy. The safe starting values are:

```
MULTB   = 100      bulk zone timestep multiplier
MULTNS  = 2        near-surface timestep multiplier
MULTC   = 0.01     contact zone timestep multiplier
DFACTNS = 1e-5     near-surface slow-motion threshold
DFACTC  = 1e-6     contact slow-motion threshold
```

If your colloid is small (AP < 1 µm), increase MULTNS — see Section 9.

### Step 5 — Set run mode

For a quick first test, run in serial mode:
```
NPART   = 5        (a few particles)
CLUSTER = 0        (serial — the code loops internally)
ATTMODE = 0        (perfect sink — simplest attachment criterion)
DIFFSCALE = 0      (no Brownian diffusion — deterministic, reproducible)
```

Once you are satisfied the setup is correct, switch to production:
```
NPART   = 100+     (enough for statistics)
CLUSTER = 1        (parallel — one worker per particle)
ATTMODE = 1        (torque-balance — physically realistic)
DIFFSCALE = 1.35   (Brownian diffusion active)
```

---

## 5. Running the simulation

### Serial mode (CLUSTER=0) — development and testing

Run the Python script directly from your run directory:

```bash
cd my_run/
python3 ../traj_jet.py     # jet — reads INPUT_jet.IN from current directory
python3 ../traj_hap.py     # hap — reads INPUT_hap.IN from current directory
```

The code reads `INPUT_jet.IN` or `INPUT_hap.IN` from the current directory.
Output flux files are written to the current directory. Progress is printed to
the terminal as each particle completes.

### Parallel mode (CLUSTER=1) — production runs

Parallel runs are submitted via the SLURM batch system using the orchestration
scripts in the `python/` directory. Each particle runs as a separate worker.

```bash
cd my_run/
sbatch job_slurm_jet           # jet
sbatch job_slurm_hap           # hap
```

The SLURM script calls `jet.csh` / `hap.csh`, which:
1. Builds a job list (one line per particle)
2. Submits workers via `mpirun submit`
3. Waits for all workers to complete
4. Concatenates per-particle output files into consolidated flux files
5. Copies results back to the run directory

Output files appear in your run directory (`DATADIR`) when the job finishes.

> **Important**: In CLUSTER=1 mode, set NPART in `INPUT_jet.IN` / `INPUT_hap.IN`
> to the total number of particles you want. The SLURM script reads this value
> and dispatches that many workers.

### Single-particle diagnostic run (CLUSTER=1, fixed injection point)

To reproduce a specific particle trajectory (e.g. for comparison with the
Fortran reference code), use the `_compare` SLURM script, which calls Python
directly and passes an injection point:

```bash
sbatch job_slurm_hap_compare   # hap — passes XINIT and YINIT as arguments
```

This bypasses the `submit` dispatcher and allows more than 5 arguments to be
passed to the Python script. Edit `job_slurm_hap_compare` to set the desired
XINIT and YINIT values. There is no equivalent for the jet code (not needed —
the jet geometry does not have the same stagnation-axis injection issue).

---

## 6. Monitoring a run in progress

Three sources of information are available while a parallel job runs.

### master.out — overall job progress

Written by the `submit` dispatcher to the scratch directory as workers are
dispatched and complete:

```bash
cat $WORKDIR/master.out
```

Shows which particle indices have been dispatched, which are running, and which
have finished. Check this first to confirm the job started correctly.

### Per-particle flux files — real-time results

Each worker writes its own flux file as soon as its particle finishes. You can
check how many particles have completed without waiting for the full job:

```bash
ls -la $WORKDIR/JETFLUX*.OUT        # jet
ls -la $WORKDIR/HAPHETFLUX*.OUT     # hap
```

Count the files to see how many particles are done.

### SLURM output file — step-by-step detail

For particles still running, the SLURM output file (`slurm-XXXXXXX.out` in
the scratch directory) contains a progress line every 10,000 steps:

```
step=    10000  H=1.234E-07  HFLAG=2  R=2.456E-04  AFRACT=0.4595
```

What to look for:

| Field | What it tells you |
|-------|------------------|
| `HFLAG=1` | Particle in bulk — no surface forces yet |
| `HFLAG=2` | Particle in near-surface zone — surface chemistry active |
| `HFLAG=3` | Particle in contact zone — Born repulsion and deformation active |
| `H` | Current surface-to-surface separation (m) |
| `AFRACT=−1` | Heterodomain system inactive (bulk zone, or SCOV=SCOVP=0) |
| `AFRACT≈0.46` | Colloid heterodomains overlapping ZOI — normal for SCOVP≈0.39 |
| `AFRACT≈0.49–0.51` | Collector heterodomain also overlapping — attachment likely |

If you see HFLAG=1 for many thousands of lines without any HFLAG=2 appearing,
the particle is likely going to exit without approaching the surface.

---

## 7. Understanding your results

### Output files

After a parallel run completes, three consolidated files appear in your run
directory:

| File (jet) | File (hap) | Contents |
|------------|------------|---------|
| `JETFLUXATT.OUT` | `HAPHETFLUXATT.OUT` | Attached particles (ATTACHK = 2, 4, or 6) |
| `JETFLUXEX.OUT` | `HAPHETFLUXEX.OUT` | Exited particles (ATTACHK = 1) |
| `JETFLUXREM.OUT` | `HAPHETFLUXREM.OUT` | Remaining / retained particles (ATTACHK = 3 or 5) |

Each file has a 4-line parameter header, an ATTACHK legend, a column header
line, and then one data row per particle.

In serial mode (CLUSTER=0), the same three files are written directly (no
per-particle intermediates).

### The six outcome codes (ATTACHK)

| ATTACHK | Name | What happened |
|---------|------|--------------|
| 1 | Exit | Particle left the simulation domain without attaching |
| 2 | Attached — arrest or sink | Particle reached the surface and stopped (torque arrest or perfect sink) |
| 3 | Remaining | Simulation time TTIME expired; particle was still mobile |
| 4 | Attached — contact slow-motion | Particle in contact and effectively immobile (diffusion comparison criterion) |
| 5 | Retained — near-surface | Particle hovering in secondary energy minimum, not reaching contact |
| 6 | Crashed | Particle numerically penetrated below minimum separation H0 |

**ATTACHK = 2** is the primary attachment outcome. Under ATTMODE=1 it means the
adhesive torque was large enough to stop the particle (or force equilibrium was
reached quickly). Under ATTMODE=0 it means the particle entered the contact zone.

**ATTACHK = 4** is a secondary attachment outcome — the particle is stuck in
contact but never experienced a large enough adhesive torque to clamp UT to zero.
Physically it represents contact at the stagnation point or under very low flow
conditions. Counts as attached for efficiency calculations.

**ATTACHK = 6** should not appear frequently. If it does, reduce MULTC.

### Key flux output columns

| Column | Meaning |
|--------|---------|
| `XINIT, YINIT, RINIT` | Injection position (m) |
| `XOUT, YOUT, ZOUT` | Final position at outcome (m) |
| `H` | Final surface separation (m) |
| `ETIME` | Time from near-surface entry to outcome (s) |
| `PTIMEF` | Total simulation time (s) |
| `TBULK, TNEAR, TFRIC` | Time spent in bulk / near-surface / contact zones (s) |
| `NSVISIT, FRICVISIT` | Number of times the particle entered near-surface / contact |
| `AFRACT` | Fraction of zone of influence overlapping attractive heterodomains at final state |
| `ACONT` | Contact radius at attachment (m); 0 if not attached |
| `ATTACHK` | Outcome code (see table above) |
| `HETFLAG` | 1 if any heterodomain overlap occurred; 0 otherwise |
| `HETTYPE` | Type of heterodomain overlap (0=none, 1=large, 2=medium, 4=both) |

### Computing attachment efficiency

Attachment efficiency α is simply the fraction of simulated particles that
attached:

```
α = (count of ATTACHK=2 + ATTACHK=4 + ATTACHK=6) / NPART
```

Note: ATTACHK=6 (crashed) is counted as attached because the particle did
reach the surface. However, frequent crashes indicate a timestep problem (see
Troubleshooting) and those runs should be rerun with smaller MULTC before
using the results.

### What AFRACT tells you

AFRACT is computed at every near-surface step and recorded in the flux file
at the moment of the final outcome. It represents the fraction of the Zone
of Influence (a disk on the collector surface centred under the colloid)
that overlaps attractive surface patches.

| AFRACT value | Interpretation |
|-------------|----------------|
| −1.0 | Heterodomain system inactive (bulk zone or no heterodomains set) |
| 0.0 | Near-surface, but no ZOI overlap with any heterodomain |
| ~0.46 | Colloid heterodomains only overlapping ZOI (typical for SCOVP≈0.39) |
| ~0.49–0.51 | Collector heterodomain also overlapping — attachment very likely |
| > 0.5 | Strong combined overlap — arrest almost certain |

AFRACT is the key diagnostic for whether heterodomain chemistry drove the
attachment event. If all your attached particles have AFRACT near zero, the
attachment was driven by bulk-favorable conditions (opposite zeta potentials)
rather than by the heterodomain patches.

---

## 8. Choosing your physics settings

### Favorable vs unfavorable conditions

**Favorable** means ZETAPST and ZETACST have opposite signs. The electrostatic
double-layer force is attractive everywhere. Particles reaching the near-surface
zone approach contact readily. Attachment efficiency under ATTMODE=0 approaches 1.

**Unfavorable** means ZETAPST and ZETACST have the same sign. The double-layer
force is repulsive — there is an energy barrier. Particles attach only if
heterodomains (SCOV > 0 or SCOVP > 0) bring the net force locally attractive.
Without heterodomains, all particles will exit or remain (ATTACHK=1 or 3).

### ATTMODE: which attachment model to use

**ATTMODE=0 (perfect sink)** — any particle that enters the contact zone
attaches immediately. Use this for:
- Bounding calculations (maximum possible attachment efficiency)
- Quick parameter sweeps where you just want to know if particles reach the surface
- Transport-dominated problems where surface mechanics are not of interest

**ATTMODE=1 (torque-balance)** — attachment requires either torque arrest
(ATTACHK=2) or contact slow-motion (ATTACHK=4). This is the physically realistic
mode. Use it for:
- Quantitative comparison with experimental attachment efficiencies
- Studying the role of surface roughness and contact mechanics
- Any situation where you want to distinguish transport limitation from
  attachment limitation

Under ATTMODE=1, the attachment fraction will always be ≤ the ATTMODE=0 value.
The difference measures the fraction of particles that reach the surface but
bounce off.

### VDW coating model (VDWMODE)

| VDWMODE | Surface configuration |
|---------|----------------------|
| 1 | Both surfaces uncoated — use combined Hamaker constant A132 |
| 2 | Coated colloid + coated collector — use A11, AC1C1, A22, AC2C2, A33, T1, T2 |
| 3 | Bare colloid + coated collector — use A11, AC2C2, A22, A33, T2 |
| 4 | Coated colloid + bare collector — use A11, AC1C1, A22, A33, T1 |

For VDWMODE=1, set A132 and leave A11–AC2C2 at zero. For VDWMODE=2–4, set
A132=0 and provide the individual Hamaker constants.

### Surface roughness (RMODE, B, ASP)

| RMODE | Configuration |
|-------|--------------|
| 0 | Smooth–smooth: no asperities on either surface |
| 1 | Rough colloid: asperities of height ASP on colloid surface |
| 2 | Rough collector: asperities of height ASP on collector surface |
| 3 | Both surfaces rough |

`B` is the hydrodynamic slip length (m). B=0 means full lubrication (most
conservative — slowest near-surface approach). B > 0 reduces lubrication
retardation and speeds up contact. Start with B=0 unless you have a specific
physical reason for slip.

**Warning**: Combining roughness (RMODE > 0, ASP > 0, B > 0) with heterodomain
coverage on both surfaces is the most computationally expensive configuration.
Submit such runs as batch jobs — they can take hours per particle in Python.

### Gravity and diffusion

```
GRAVFACT = 0.0    neutrally buoyant (gravity off)
GRAVFACT = 1.0    gravity active
DIFFSCALE = 0.0   no Brownian diffusion (deterministic)
DIFFSCALE = 1.35  Brownian diffusion active (calibrated value)
```

For initial testing, set both to zero for fully deterministic, reproducible
trajectories. For production runs, use GRAVFACT=1.0 if your particles are
not neutrally buoyant, and DIFFSCALE=1.35 for realistic Brownian motion.

Note: with DIFFSCALE > 0, trajectories are stochastic — two particles with
identical injection points will follow different paths. This is physically
correct. Set DIFFSCALE=0 only when comparing with the Fortran reference code
step by step.

For `traj_hap.py`, `CBGRAV` controls the direction of gravity relative to
the flow (1 = with flow, 2 = against, 3 and 4 = orthogonal). For
`traj_jet.py`, gravity always acts in the Z direction; use GRAVFACT=−1 or
+1 to set direction.

---

## 9. Performance: how long will it take?

### What controls run time

Run time is determined almost entirely by how many timesteps the particle
spends in the near-surface zone, multiplied by the cost per step.

**Timesteps in near-surface zone** scales as 1/MULTNS and as 1/AP² (smaller
particles have a smaller momentum relaxation time dTMRT and therefore smaller
absolute timesteps). The near-surface zone width is fixed at ~200 nm; a 500 nm
colloid traverses it much more slowly than a 2.2 µm colloid in terms of wall-
clock time.

**Cost per step** is higher for `traj_hap.py` than `traj_jet.py` due to the
analytic Happel flow field, 3D vector gravity decomposition, and quaternion
heterodomain geometry. For the same parameters, expect `traj_hap.py` to be
noticeably slower per particle than `traj_jet.py`.

### Recommended MULTNS by colloid size

| AP | Recommended MULTNS | Expected near-surface steps |
|----|-------------------|---------------------------|
| ≥ 2 µm | 2–10 | 10,000–100,000 — fast |
| 1 µm | 10–20 | ~500,000 |
| 500 nm | 20–25 | ~1–2 million — slow |
| < 500 nm | 25–50 | > 2 million — submit as batch job |

**Caution with large MULTNS under unfavorable conditions**: If MULTNS is too
large, a single timestep could carry the particle through the repulsive energy
barrier peak without resolving it — effectively numerical tunnelling. Validate
unfavorable runs by confirming that particles produce ATTACHK=1/3/5 outcomes
(not surprise attachments). Reduce MULTNS if unexpected attachment occurs.

### When to run serial vs parallel

| Situation | Recommended mode |
|-----------|-----------------|
| First test, 1–5 particles | Serial (CLUSTER=0) from the command line |
| Parameter sweep, quick check | Serial with NPART=5–10 |
| Production run, NPART ≥ 20 | Parallel (CLUSTER=1) via SLURM |
| Complex roughness + heterodomains, any NPART | Parallel via SLURM |
| AP < 1 µm, any NPART | Parallel via SLURM |

### Run time ballparks (traj_hap.py, AP=2.2 µm, favorable conditions)

| Configuration | Approx. time per particle |
|---------------|--------------------------|
| Simple (no roughness, no heterodomains, MULTNS=2) | < 1 minute |
| RMODE=1, SCOV=0.001, SCOVP=0.39, MULTNS=2 | ~2–3 hours |
| Same, but MULTNS=10 | ~30–40 minutes |

For `traj_jet.py` with the same parameters, times are substantially shorter.

---

## 10. Troubleshooting

### All particles exit (ATTACHK=1) under what should be favorable conditions

- Check that ZETAPST and ZETACST are **opposite** in sign.
- Check that ATTMODE is not set to a value you did not intend.
- For `traj_jet.py`: verify REXIT is not smaller than your injection radius RLIM.
- Increase TTIME — particles may be exiting because the simulation clock expires
  before they approach the surface.

### All particles return ATTACHK=3 (remaining — time expired)

- TTIME is too short. Double it and rerun.
- Under unfavorable conditions with no heterodomains (SCOV=SCOVP=0), this is
  the correct result — particles never attach. Add heterodomains if you want
  to model unfavorable attachment.

### Simulation appears to hang (particles taking millions of steps)

Not a bug. For AP ~ 500 nm with MULTNS=2, the near-surface zone can require
1–2 million steps (~20–70 minutes per particle in Python). Increase MULTNS to
20–25 for 500 nm colloids. See Section 9 for size guidance.

### ATTACHK=6 (crash) appearing frequently

The particle numerically penetrated below H0=0.158 nm. The Born repulsion
gradient near this distance is extremely steep (H⁻⁸) and the timestep in the
contact zone is too large. Reduce MULTC — try 0.001 instead of 0.01. Do not
increase MULTC to improve speed; the contact zone is not a performance bottleneck.

### AFRACT = 0.0 throughout near-surface zone despite SCOV > 0 or SCOVP > 0

The heterodomain projection system is running but producing no overlap. The most
common cause is an incorrect RZOIBULK value in the code — check the flux file
header and verify it is in the range of ~100–300 nm for typical parameters. This
is a code issue, not an input issue, and should not occur in the current validated
version. If it does, contact the code maintainer.

### All particles attach at ATTACHK=4 but you expected ATTACHK=2

ATTACHK=4 (contact slow-motion) fires when the particle is stuck at the stagnation
point where the tangential fluid velocity is zero, so the torque-arrest path
(ATTACHK=2) cannot drive UT negative. This is correct physical behaviour for
stagnation-axis injection. To exercise the torque-arrest path, increase RLIM so
particles inject off-axis where VT > 0.

### AFRACT = −1.0 in all output rows

Expected behaviour when SCOV=0 and SCOVP=0, or when all particles exit in the
bulk zone (HFLAG=1 throughout). Not an error.

### Run starts but all particles finish in 0.007 s with ATTACHK=1

The python3 binary was not found by the worker processes. This is a cluster
configuration issue — the full path to python3 must be hardcoded in the job
list. Check `jet.csh` / `hap.csh` and confirm the python3 path matches the
output of `which python3` on the cluster.

### Trajectory files are not being written

Trajectory files are only written when NPART < 10. This is intentional — in
production runs they would consume excessive disk space. Set NPART=1 or NPART=5
for diagnostic runs if you need trajectory output.

---

## 11. Quick-reference parameter tables

### Must-set parameters (every run)

| Parameter | Code | What to set |
|-----------|------|------------|
| `NPART` | both | Number of particles (1–5 for testing, 100+ for production) |
| `ATTMODE` | both | 0 = perfect sink; 1 = torque-balance (realistic) |
| `CLUSTER` | both | 0 = serial; 1 = parallel (SLURM) |
| `AP` | both | Colloid radius (m) |
| `ZETAPST` | both | Colloid zeta potential (V) |
| `ZETACST` | both | Collector zeta potential (V) — opposite sign to ZETAPST for favorable |
| `IS` | both | Ionic strength (mol/m³) |
| `TTIME` | both | Max simulation time per particle (s) |
| `VSUP` | hap | Superficial fluid velocity (m/s) |
| `AG` | hap | Grain radius (m) |
| `POROSITY` | hap | Bed porosity |
| `CBGRAV` | hap | Gravity direction (1–4) |
| `VJET` | jet | Jet velocity (m/s) |
| `REXIT` | jet | Radial exit boundary (m) |

### Timestep parameters (tune for speed vs accuracy)

| Parameter | Safe default | Notes |
|-----------|-------------|-------|
| `MULTB` | 100 | Bulk timestep — increase to 500–1000 for faster bulk traversal |
| `MULTNS` | 2 (large AP); 20 (small AP) | Near-surface — see Section 9 table |
| `MULTC` | 0.01 | Contact zone — reduce to 0.001 if ATTACHK=6 crashes appear |
| `DFACTNS` | 1×10⁻⁵ | Near-surface slow-motion threshold |
| `DFACTC` | 1×10⁻⁶ | Contact slow-motion threshold |

### Outcome quick reference

| ATTACHK | Attached? | Action if unexpected |
|---------|-----------|---------------------|
| 1 | No — exited | Check zeta potential signs and REXIT/TTIME |
| 2 | **Yes** | Primary attachment outcome |
| 3 | No — time expired | Increase TTIME; or conditions are genuinely unfavorable |
| 4 | **Yes** | Secondary attachment; normal for stagnation-axis injection |
| 5 | Hovering | Particle in secondary energy minimum; increase TTIME or SCOV |
| 6 | Yes (crash) | Reduce MULTC |

### Where to find more detail

| Topic | Document |
|-------|----------|
| Full parameter definitions | [traj_glossary.md](traj_glossary.md) |
| Attachment physics and zone logic | [traj_attachment.md](traj_attachment.md) |
| Trajectory loop flowchart | [traj_flowchart.html](traj_flowchart.html) |
| Heterodomain geometry details | traj_glossary.md, Section 5a |
| Timestep guidance by colloid size | traj_glossary.md, Section 12 |
| JKR contact mechanics | traj_glossary.md, Section 10 |
| VDW coating modes | traj_glossary.md, Section 7 |
