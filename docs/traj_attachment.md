# traj_hap.py / traj_jet.py — Understanding Attachment Criteria

## Overview

This document covers both simulation codes. The attachment criteria,
zone structure, and outcome logic are identical between `traj_hap.py`
and `traj_jet.py`. The only differences are geometric:

- **traj_hap.py**: Happel sphere-in-cell geometry. Separation distance
  H = R − AG − AP (+ roughness correction). Normal direction is radially
  outward from collector centre.
- **traj_jet.py**: Impinging jet geometry. Separation distance H = Z − AP.
  Normal direction is vertical (Z axis).

All attachment outcomes (ATTACHK values), zone transitions, slow-motion
criteria, and physical interpretations described below apply equally to
both codes unless explicitly noted.

The loop `while ATTACHK == 0` runs until one of the criteria below is met.

---

## The six outcomes (ATTACHK values)

| Value | Name | Physical meaning |
|-------|------|-----------------|
| 1 | Exit | Particle escaped the simulation domain |
| 2 | Attached — perfect sink or arrest | Contact established; particle came to rest |
| 3 | Remaining | Simulation time TTIME exceeded; particle still mobile |
| 4 | Attached — contact slow-motion | Particle in contact, tangentially immobile |
| 5 | Retained — near-surface slow-motion | Particle hovering near surface, not progressing to contact |
| 6 | Crashed | Particle penetrated below minimum separation H0 |

**Exit domain (ATTACHK=1)**:
- **traj_hap.py**: R > RB (outer Happel shell), with Z < 0 for CBGRAV=1,2
  (particles at R > RB with Z ≥ 0 are reflected back rather than exited)
- **traj_jet.py**: R > REXIT (radial exit boundary)

---

## The three zones and their role in attachment

The simulation divides the gap between particle and collector into three
zones, controlled by `HFLAG`.

**Bulk (HFLAG=1)**
- **traj_hap.py**: H > HNS (read from INPUT_hap.IN, typically 2×10⁻⁷ m)
- **traj_jet.py**: H > 2×10⁻⁷ m (hardwired)

Full flow field active. Large timestep (MULTB × dTMRT). No attachment
checks. No heterodomain EDL forces.

**Near-surface (HFLAG=2, HFRIC < H ≤ HNS)**
Close enough for surface forces to matter. Timestep reduced to
MULTNS × dTMRT. Near-surface slow-motion check (IREF1) active.
Heterodomain EDL forces active (HFLAG > 1 gates this calculation).

**Contact (HFLAG=3, H ≤ HFRIC)**
Within the contact zone. Timestep drops sharply to MULTC × dTMRT to
resolve Born repulsion and JKR deformation mechanics. Brownian diffusion
suppressed. Contact slow-motion check (IREF2) active.

**Zone transitions:**
- Bulk → Near-surface: IREF1 initialised, dT reduced, NSVISIT incremented
- Near-surface → Contact: IREF2 initialised, dT reduced further, FRICVISIT incremented
- Contact → Near-surface: IREF2 **reset to zero**, dT restored to MULTNS level
- Near-surface → Bulk: IREF1 **reset to zero**, dT restored to MULTB level

The resets are important: a particle that oscillates in and out of a zone
must accumulate 1000 consecutive steps *within* that zone to trigger the
slow-motion attachment checks.

---

## HFRIC and HMIN

`HFRIC` marks the contact zone boundary. It is computed at startup as the
separation at which each of the short-range forces (Born, steric, AB)
drops below 0.01% of its value at H0 (= 0.158 nm). `HFRIC` is typically
in the range 5–20 nm depending on colloid size and surface chemistry.

`HMIN` is the separation at the net-force energy minimum — where Born
repulsion exactly balances all attractive forces. This marks the deepest
deformation state DELTAMAX.

Both are computed by `find_hfric_hmin()` using the `scipy.optimize.brentq`
root-finding algorithm.

---

## ATTMODE = 0: Perfect sink

The moment H ≤ HFRIC, the particle is declared attached:

    if ATTMODE == 0:
        ATTACHK = 2

No torque balance, no slow-motion check. Use this mode for maximum
attachment efficiency or when studying transport rather than retention
mechanics.

---

## ATTMODE = 1: Torque-balance contact mode

A particle in contact must satisfy one of two criteria.

### Criterion A: Arrest (ATTACHK = 2)

A particle arrests when:
1. Its tangential velocity UT is driven to zero (or negative) by adhesive
   torque, AND
2. The adhesive and repulsive normal forces are in equilibrium.

The tangential velocity in the contact zone is updated by a torque-balance
equation (Ma et al. 2011). The relevant forces are:

- **Driving torque**: fluid tangential velocity VT exerts a rolling moment
  via lubrication correction coefficients (FSHRT, TSHRY).
- **Resisting torque**: adhesive normal force FADH multiplied by lever arm
  RLEV opposes rolling.

If FADH is large enough, UT goes negative. Since backward rolling is not
physical, UT is clamped to zero and ARRESTFLAG set to 1. On the next step,
if normal forces are in equilibrium (FADH within 0.5% of FREP), ATTACHK=2
is assigned.

**ARRESTFLAG details**: The equilibrium reset runs as an independent check
every step. If equilibrium has not yet been reached, ARRESTFLAG is
immediately reset to 0 even though UT was just clamped. This prevents
premature attachment during the approach phase. ATTACHK=2 via this path
only fires once the particle has genuinely settled at its equilibrium
separation.

**Stagnation-point particles (VT = 0)**:
On the forward stagnation axis, the flow field gives exactly zero tangential
fluid velocity. The driving term in the torque equation vanishes. UT decays
asymptotically toward zero from above and never crosses it. ARRESTFLAG is
never set via the torque-driven path alone. However, if the adhesive normal
force FADH is large enough to nearly balance FREP immediately on contact
entry — as can occur with strong heterodomain attraction (AFRACT≈0.49+) —
the equilibrium condition FADH≈FREP can be satisfied within one or two steps,
allowing ATTACHK=2 to fire even at the stagnation point. Without heterodomain
attraction (unfavorable bulk conditions, SCOV=SCOVP=0), stagnation-axis
particles rely entirely on Criterion B (ATTACHK=4).

**Practical implication for RLIM**: ATTACHK=2 (arrest) is the more definitive
and physically meaningful attachment outcome — adhesive torque or rapid force
equilibration stops the particle. ATTACHK=4 (contact slow-motion) is a weaker
criterion based on diffusion comparison. To exercise the ATTACHK=2 torque-driven
path, particles should inject **off-axis** (RLIM large enough that VT > 0).
Small RLIM (e.g. RLIM=1e-7 m) forces stagnation-axis injection; ATTACHK=2
may still occur if heterodomain attraction is strong, but ATTACHK=4 is the
fallback for weaker conditions. Production runs should use RLIM commensurate
with the grain radius to sample the full range of injection positions.

Note: In the Happel geometry, the stagnation axis is the Z-axis (RLIM → 0).
In the jet geometry, the stagnation point is at the centre of the impingement
zone (R = 0, Z ≈ 0).

---

## Impact of ATTMODE

ATTMODE is one of the most important simulation parameters. It controls
whether attachment requires physical force equilibration or is assumed
instantaneous on contact.

### ATTMODE = 0 — Perfect sink
Any contact (H ≤ HFRIC) immediately produces ATTACHK=2. No torque balance,
no slow-motion check. Every particle that reaches the contact zone attaches.
Use for:
- Maximum attachment efficiency studies
- Transport-dominated problems where retention mechanics are not of interest
- Quick validation runs to confirm particles are reaching the collector

### ATTMODE = 1 — Torque-balance contact mode
Attachment requires either torque arrest (ATTACHK=2) or contact slow-motion
(ATTACHK=4). Particles can enter and exit the contact zone multiple times
without attaching if the adhesive torque is insufficient to stop them or the
IREF2 slow-motion criterion is not met.

This is the physically realistic mode. Expected outcomes depend on conditions:

| Condition | Likely outcome |
|-----------|---------------|
| Favorable, off-axis, strong adhesion | ATTACHK=2 (torque arrest) |
| Favorable, stagnation axis, strong heterodomain attraction | ATTACHK=2 (force equilibration) |
| Favorable, stagnation axis, no heterodomains | ATTACHK=4 (contact slow-motion) |
| Unfavorable, with heterodomains, off-axis | ATTACHK=2 or ATTACHK=4 |
| Unfavorable, no heterodomains | ATTACHK=1 or ATTACHK=3/5 (never contacts) |
| Any condition, particle overshoots H0 | ATTACHK=6 (crashed) |

**Key distinction**: Under ATTMODE=1, attachment fraction is always ≤ that
under ATTMODE=0 for the same conditions. The difference quantifies the
fraction of particles that reach contact but are not retained — an important
measure of the role of surface mechanics in colloid retention.

### Criterion B: Contact slow-motion (ATTACHK = 4)

Catches particles genuinely stuck in contact where UT never goes negative.

Every step in the contact zone, a reference position is recorded. After
1000 consecutive contact steps, the code compares:

    DREF2 (tangential displacement from reference)
    vs.
    DIND2 = DFACTC × √(6 × DCOEF × KB × T × TREF2 / M3)

If DREF2 < DIND2, the particle has moved less than expected from diffusion
alone — it is effectively immobile — and ATTACHK=4 is assigned.

**Critical implementation detail**: DREF2 uses only the *tangential*
component of displacement, excluding normal-direction motion. A particle at
the Born-force minimum oscillates normally against the strong short-range
repulsion. Including this normal bouncing in DREF2 would cause it to exceed
DIND2 on every check, resetting IREF2 to zero forever and producing a
simulation that never terminates. This was Bug 2 in the original port of
traj_hap.py and has been corrected.

If DREF2 ≥ DIND2, the particle is still mobile, IREF2 resets to zero, and
the check restarts from the current position.

---

## Near-surface retention (ATTACHK = 5)

A particle can be retained in the near-surface zone without reaching contact
when, after 1000 consecutive near-surface steps:

Either:
(a) 3D displacement < DFACTNS × diffusion scale, AND H > 5×HFRIC
    (particle is not close to contact), OR
(b) The particle is in the rear stagnation zone (|Z + R| ≤ AP/2)
    (hap only — identifies the low-velocity recirculation region behind
    the collector)

Condition (a) identifies particles hovering in a secondary energy minimum.
The 5×HFRIC guard prevents this check from firing while the particle is
actively being drawn toward contact by attractive forces.

---

## Convergence speed in the near-surface zone

The absolute near-surface timestep is `MULTNS × dTMRT = MULTNS × MP/M3`,
which scales as AP². For small colloids (AP ~ 500 nm) with no slip (B=0),
the near-surface zone may require millions of steps to traverse in Python
even though the Fortran completes the same steps ~100× faster.

**Recommended MULTNS by colloid size:**

| AP | Recommended MULTNS |
|----|-------------------|
| ≥ 1 µm | 2–10 |
| 500 nm | 10–25 |
| < 500 nm | 25–50 |

This is a performance issue, not a physics difference between Python and
Fortran. The results are identical; the Fortran simply runs faster.

### traj_hap.py is inherently slower per step than traj_jet.py

For the same colloid size and number of timesteps, `traj_hap.py` has a
higher per-step cost than `traj_jet.py`. This is a consequence of simulating
a harder geometry, not a code quality difference. The main contributors:

- **Flow field**: `happel_ff()` evaluates an analytic Stokes solution
  (square-roots, polynomial chains) at every step. `jet_ff()` uses a rational
  polynomial with 14 coefficients pre-computed once before the loop — each call
  is two fraction evaluations.
- **Gravity**: `traj_hap.py` calls `gravvect()` to decompose gravity into
  normal/tangential components relative to the curved surface every step.
  `traj_jet.py` adds gravity as a single scalar to UZ.
- **Velocity integration**: `traj_hap.py` decomposes velocity into normal and
  tangential frames, updates each separately, then recomposes. `traj_jet.py`
  updates three independent scalars.
- **Heterodomain geometry**: `traj_hap.py` applies a quaternion-based 3D
  rotation (`_rotation_matrix`, `_transformation`) to project heterodomains
  onto the sphere's tangent plane at every near-surface step. `traj_jet.py`
  works in 2D polar coordinates on a flat surface with no rotation.

When comparing run times between the two codes at the same MULTNS, expect
`traj_hap.py` to take noticeably longer per particle even for identical physics
parameters. The gap is largest when heterodomains and roughness are both active.

### Complex heterodomain + roughness cases

Runs combining **nanoscale roughness** (B > 0, RMODE > 0, ASP > 0) with
**heterodomain coverage** on both collector and colloid are significantly
slower in Python than simple cases, even for large colloids (AP=2.2µm).
The heterodomain geometry functions (hettrack, hettrackp, fractional_area)
are evaluated at every near-surface step, and their cost dominates when
the particle spends many steps in the near-surface zone.

Observed example (AP=2.2µm, B=110nm, ASP=17nm, RMODE=1, SCOV=0.00135,
SCOVP=0.39, HETMODE=1, HETMODEP=1, MULTNS=2):
- Fortran: 911,556 total steps, completes in seconds
- Python: ~104 seconds per 10,000 steps → ~2.6 hours total

For such cases, **submit as a batch job** rather than running interactively.
MULTB does not help — the bulk traversal may be only ~20,000 steps while
the near-surface zone dominates with ~890,000 steps.

---

## Heterodomain system and AFRACT

AFRACT is the key output of the heterodomain system. It is computed at every
near-surface step (HFLAG=2 or 3) and represents the fraction of the Zone of
Influence (ZOI) that overlaps at least one attractive surface — either a
collector heterodomain (SCOV>0) or a colloid heterodomain projection (SCOVP>0).

AFRACT drives a four-component weighted average of the EDL force:

| Component | Collector surface | Colloid surface | EDL character |
|-----------|------------------|-----------------|---------------|
| AF_Z | Plain (ZETACST) | Plain (ZETAPST) | Repulsive (unfavorable) |
| AF_PZ | Plain (ZETACST) | Het (ZETAHETP) | Depends on signs |
| AF_ZH | Het (ZETAHET) | Plain (ZETAPST) | Depends on signs |
| AF_PZH | Het (ZETAHET) | Het (ZETAHETP) | Attractive (favorable patch) |

The net FEDL is the area-weighted sum of these four force components. When
AFRACT is large (approaching 0.5+), the attractive heterodomain contribution
dominates and attachment becomes likely. When AFRACT is near zero, the
repulsive bulk EDL prevails.

**AFRACT interpretation guidelines:**

| AFRACT | Physical interpretation |
|--------|------------------------|
| −1.0 | Bulk zone (HFLAG=1) or SCOV=SCOVP=0 — heterodomain system inactive |
| 0.0 | Near-surface but no ZOI overlap with any heterodomain |
| ~0.46 | Typical with colloid heterodomains only (SCOVP=0.39, HETMODEP=1) |
| ~0.49–0.51 | Collector heterodomain also overlapping ZOI — attachment likely |
| >0.5 | Strong combined overlap — arrest (ATTACHK=2) very likely |

**AFRACT=0 despite SCOV>0 or SCOVP>0**: Almost always caused by an incorrect
RZOIBULK formula. Verify `RZOIBULK = 2.0·sqrt((1/KAPPA)·AP)` with the factor
of 2 outside the square root.

**Collector heterodomain overlap is rare under sparse coverage**: With
SCOV=0.00135, collector heterodomain ring spacing (~7.6µm) is much larger
than RZOIBULK (~186nm). Overlap only occurs when the particle enters the
near-surface zone very close to a heterodomain centre. With small NPART this
may never occur. To force overlap use small RLIM (e.g. 1×10⁻⁷ m) to inject
near the stagnation axis, or run large NPART (100+).

For a full description of the generation geometry, projection pipeline, and
fractional area calculation, see Section 5a of the parameter glossary.

---

## Favorable vs unfavorable conditions

**Favorable (opposite-sign zeta potentials)**:
FEDL is attractive everywhere. No energy barrier. Particles reaching the
near-surface zone approach contact quickly. Expected outcomes:
- ATTMODE=0: all particles → ATTACHK=2
- ATTMODE=1, off-axis: ATTACHK=2 (arrest) or ATTACHK=6 (crashed)
- ATTMODE=1, stagnation axis (small RLIM): ATTACHK=4 (contact slow-motion)

Note: ATTACHK=6 (crashed) is physically meaningful under favorable
conditions — the particle accelerates toward the surface and overshoots H0
before the Born repulsion halts it. This typically indicates MULTC is too
large; reduce it if ATTACHK=6 is undesirable.

**Unfavorable (same-sign zeta potentials)**:
FEDL is repulsive. Classical DLVO energy barrier. Most particles are
repelled. Attachment occurs only via heterodomains (SCOV > 0). The variable
AFRACT (fraction of the zone of influence overlapping heterodomains)
controls whether the net EDL force is locally attractive.

Without heterodomains (SCOV = 0), expected outcomes are ATTACHK=1 (exit)
or ATTACHK=3/5 (remaining/retained). This is the correct physical result.

---

## Timeout and exit conditions

**ATTACHK = 3 (remaining)**:
PTIMEF > TTIME and no other criterion fired. The particle was still mobile
when the simulation clock expired. Under unfavorable conditions with a weak
barrier, many particles may receive ATTACHK=3. Increase TTIME if needed.

**ATTACHK = 6 (crashed)**:
H < H0 (0.158 nm). The particle has numerically penetrated below the
physical minimum separation. Usually indicates MULTC is too large for the
sharp Born repulsion at very small H. Reduce MULTC if this occurs frequently.

---

## Common issues and diagnostics

**Simulation appears to hang (particles running millions of steps)**:
For small colloids (AP ~ 500 nm) with MULTNS=2, traversing the near-surface
zone can take 1–2 million steps in Python (~20–70 minutes per particle).
Increase MULTNS. This is not a bug — it is a consequence of the small
momentum relaxation time dTMRT for small colloids.

**All particles receive ATTACHK=3 (remaining)**:
Either TTIME is too short, or conditions are genuinely unfavorable with no
heterodomains. Increase TTIME or add SCOV > 0.

**All particles exit (ATTACHK=1) under favorable conditions**:
Check ZETAPST and ZETACST are opposite in sign. Verify ATTMODE setting.
For jet geometry, check REXIT is not smaller than the injection radius.

**ATTACHK=4 never fires (stagnation-axis injection)**:
Verify DREF2 is computed from tangential displacement only (not full 3D).
This was corrected in Bug 2 of traj_hap.py. The jet code does not have
this issue as it does not have the same stagnation-axis injection scenario.

**ATTACHK=6 (crash) observed frequently**:
Reduce MULTC (e.g. from 0.01 to 0.001). Also verify HMIN is well-defined
for your chosen parameters.

**AFRACT = −1.0 in output**:
Expected when SCOV = SCOVP = 0, or when the particle is in the bulk zone
(HFLAG=1). Not an error.

**AFRACT = 0.0 throughout near-surface zone despite SCOV>0 or SCOVP>0**:
Indicates the heterodomain system is not producing valid projections. Most
likely cause is a RZOIBULK formula error — verify that
`RZOIBULK = 2.0*((1/KAPPA)*AP)**0.5` with the factor of 2 outside the
square root. A value ~1.41× too small causes RPL to be too small, zeroing
out virtually all colloid heterodomain projections. Check the RZOIBULK
value in the flux file header against the expected value.

**AFRACT slightly lower than Fortran reference**:
The `fractional_area` three-circle overlap calculation uses an exact case tree
for most configurations, but retains a `min()` approximation for the case where
PRO, ZOI, and HET all partially overlap simultaneously (APZ=1, APH=1, AZH=1).
The Fortran uses exact polygon geometry (OVERLAP3/OVERLAP4 subroutines) for
this case. Small discrepancies in AFRACT (order 1-2%) are acceptable.

**Unexpected HMIN or HFRIC values for coated systems (VDWMODE=2,3,4)**:
Two bugs were found and fixed in `force_vdw` VDWMODE=2. If using VDWMODE=2
with an older version of the code, verify term 3 denominator is
`lam+11.12*(H+T2)**2` and term 4 log is `(H+T1)/(H+T1+2*AP)`.
Also verify LAMBDAVDW is passed correctly to `find_hfric_hmin`.

**master.out is empty after run**:
The `submit` dispatcher writes master.out only after the job completes, not
progressively. To monitor progress during a run, check the console output
or resubmit with NPART=1 in serial (CLUSTER=0) mode for diagnostic runs.

---

## Validation accuracy — Python vs Fortran

Full step-by-step comparison completed for traj_hap.py with DIFFSCALE=0, NOUT=10,
NPART=1, AP=2.2µm, ATTMODE=1, HETMODE=9, HETMODEP=1, SCOV=0.00135, SCOVP=0.39,
RMODE=1, ASP=17nm, B=110nm. Both codes produce ATTACHK=2 at the same location.

### Bulk zone agreement
| Variable | Agreement |
|----------|-----------|
| H | <0.001% — essentially perfect |
| UN (normal particle velocity) | <0.001% — essentially perfect |
| VN (normal fluid velocity) | <0.001% — essentially perfect |

### Near-surface zone agreement
| Variable | Typical agreement | Notes |
|----------|------------------|-------|
| H | <0.1% | Excellent |
| AFRACT | <0.6% typical, up to ~3% near collector het overlap threshold | Acceptable |
| FEDL first nonzero | Same step (~46,500) in both | ✅ |
| UN, VN | <0.1% | Excellent |

### Contact zone and attachment
| Variable | Fortran | Python | Diff |
|----------|---------|--------|------|
| Contact entry step | 410,250 | 409,980 | ~270 steps — acceptable |
| H at attachment | 3.215E-09 m | 3.223E-09 m | <0.3% ✅ |
| ACONT at attachment | 2.843E-08 m | 2.838E-08 m | <0.2% ✅ |
| AFRACT at attachment | 0.50900 | 0.50895 | <0.01% ✅ |
| Attachment location (X,Y,Z) | — | — | <0.001% ✅ |
| ETIME | 3.532 s | 3.530 s | <0.1% ✅ |

The ~270 step contact zone entry offset is due to ~0.1% accumulated H error
over ~410,000 near-surface steps. Both codes reach the same physical outcome
(ATTACHK=2) at essentially the same location. This level of agreement is
appropriate for a stochastic particle transport simulation.

**Note on bulk zone**: The original hap port had wrong Goldman hydrodynamic
correction coefficients (Bug 9), causing ~15% error in FDRGN from step 1 and
eventual ATTACHK=6 crash. After fixing the coefficients to match the Fortran
exactly, bulk zone agreement became essentially perfect. Always verify FUN
coefficients against the Fortran DATA statements when porting.

In CLUSTER=1 (parallel) mode, several sources of information are available
during a run. Each serves a different purpose.

### master.out — dispatcher progress (scratch directory)
Written progressively by the `submit` binary as it dispatches and tracks
workers. Check this first to see overall job progress:

```bash
cat $WORKDIR/master.out
```

Shows which particles have been dispatched, which are running, and which
have completed. Updated continuously throughout the run.

### Per-particle flux files — completed particle results (scratch directory)
Each worker writes its own flux file as soon as that particle completes.
Check outcomes in real time without waiting for the full job:

```bash
ls -la $WORKDIR/JETFLUX*.OUT      # jet — shows completed particles
ls -la $WORKDIR/HAPHETFLUX*.OUT   # hap — shows completed particles
```

### slurm output file — step-by-step progress (scratch directory)
For particles still running, the slurm output file
(`slurm-XXXXXXX.out`) contains progress lines printed every 10,000 steps:

```
step=    10000  H=1.234E-07  HFLAG=2  R=2.456E-04  AFRACT=0.4595
```

Key things to watch:
- HFLAG=2 — particle in near-surface zone, physics active
- AFRACT≈0.46 — colloid heterodomains only (SCOVP=0.39), normal
- AFRACT≈0.49–0.51 — collector heterodomain overlap, attachment likely
- HFLAG=1 throughout many lines — particle staying in bulk, likely to exit

### After the run — consolidated output (run directory)
Once the job completes, `jet.csh` / `hap.csh` concatenates all per-particle
flux files and copies them back to the run directory (DATADIR):

```
JETFLUXATT.OUT   — all attached particles (ATTACHK=2,4,6)
JETFLUXEX.OUT    — all exited particles (ATTACHK=1)
JETFLUXREM.OUT   — all remaining/retained particles (ATTACHK=3,5)
```

The per-particle scratch files are deleted after concatenation.
