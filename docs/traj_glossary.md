# traj_hap.py / traj_jet.py — Input Parameter and Variable Glossary

## Overview

This glossary covers both simulation codes. The two codes share identical
physics, force models, attachment criteria, and infrastructure. They differ
only in flow field and collector geometry:

| Aspect | traj_hap.py | traj_jet.py |
|--------|-------------|-------------|
| Flow field | Happel sphere-in-cell | Impinging jet (VanNess 2017) |
| Collector geometry | Sphere (radius AG) | Flat plate |
| Separation distance | H = R − AG − AP (+ roughness) | H = Z − AP (+ roughness) |
| Coordinate | R = distance from collector centre | Z = height above plate |
| Exit condition | R > RB (outer cell boundary) | R > REXIT (jet exit radius) |
| Force geometry | Sphere-sphere EDL/VDW | Sphere-plate EDL/VDW |
| Unique parameters | HNS, AG, POROSITY, CBGRAV, VSUP | VJET, REXIT, RJET, ZMAX |

Parameters marked **[hap]**, **[jet]**, or **[both]** below.

Input files are named `INPUT_hap.IN` and `INPUT_jet.IN` — each code reads
its own named file to prevent accidentally running with the wrong parameters.

---

## Section 1 — Simulation control

| Parameter | Code | Type | Typical value | Meaning |
|-----------|------|------|---------------|---------|
| `NPART` | both | int | 5–1000 | Number of colloid trajectories to simulate |
| `HNS` | hap | float (m) | 2×10⁻⁷ | Near-surface zone outer boundary. Particles within this distance of the collector enter the near-surface zone with reduced timestep and slow-motion checks |
| `ATTMODE` | both | int | 0 or 1 | **0** = perfect sink (any contact → immediate attachment). **1** = torque-balance (particle must satisfy arrest or slow-motion criterion) |
| `CLUSTER` | both | int | 0 or 1 | **0** = single-core run (loops over NPART internally). **1** = parallel run (each worker handles one particle; NPART and index passed as arguments) |

**Note on HNS (hap only)**: The jet code uses a hardwired near-surface threshold
of `H > 2×10⁻⁷ m`. The hap code reads this as `HNS` from INPUT_hap.IN, giving
explicit control. In both codes, particles below this threshold enter HFLAG=2.

---

## Section 2 — Flow and geometry

### Happel (hap only)

| Parameter | Type | Typical value | Meaning |
|-----------|------|---------------|---------|
| `VSUP` | float (m/s) | 1×10⁻⁴–1×10⁻³ | Superficial (approach) fluid velocity. Scales the entire Happel flow field |
| `RLIM` | float (m) | AG/10–AG | Injection radius. Particles placed randomly within a disk of this radius at the outer shell boundary R = RB. **Small RLIM → stagnation-point injection** |
| `POROSITY` | float (–) | 0.35–0.45 | Bed porosity. Determines outer shell radius RB = AG/(1−ε)^(1/3) |
| `AG` | float (m) | 1×10⁻⁴–5×10⁻⁴ | Collector (grain) radius |
| `TTIME` | float (s) | 1000–10000 | Maximum simulation time per particle |
| `CBGRAV` | int | 1–4 | Gravity direction and exit condition. **1** = gravity with flow (−Z, exit at Z<0); **2** = against flow (+Z); **3** = orthogonal (−X); **4** = orthogonal (+X) |

**Derived geometry (hap):**

| Variable | Formula | Meaning |
|----------|---------|---------|
| `RB` | AG/(1−POROSITY)^(1/3) | Happel outer fluid-cell radius |
| `PP` | AG/RB | Porosity parameter |
| `K1–K4` | Happel (1958) coefficients | Flow field streamfunction coefficients |

**Flow field cost (hap vs jet)**: `happel_ff()` evaluates an analytic Stokes solution
(square-roots, divisions, and polynomial chains) at every timestep. `jet_ff()` uses a
rational polynomial whose 14 coefficients are pre-computed once from `VJET` before the
trajectory loop begins; each call then requires only two polynomial evaluations. For the
same number of timesteps, the jet flow field evaluation is substantially cheaper than the
Happel evaluation.

### Jet (jet only)

| Parameter | Type | Typical value | Meaning |
|-----------|------|---------------|---------|
| `VJET` | float (m/s) | 5×10⁻⁴–5×10⁻³ | Jet fluid velocity at nozzle exit |
| `RLIM` | float (m) | 1×10⁻⁶–1×10⁻⁵ | Injection radius. Particles placed randomly within a disk of this radius at height ZMAX |
| `POROSITY` | float (–) | 0.35 | Used only to compute AG context; not used in jet flow field |
| `AG` | float (m) | 2×10⁻⁴–3×10⁻⁴ | Collector radius (used for force geometry) |
| `REXIT` | float (m) | ~AG | Radial exit boundary. Particles at R > REXIT receive ATTACHK=1 |
| `TTIME` | float (s) | 1000–10000 | Maximum simulation time per particle |

**Hardwired jet geometry constants (not in INPUT_jet.IN):**

| Variable | Value | Meaning |
|----------|-------|---------|
| `RJET` | 5.0×10⁻⁴ m | Jet nozzle radius |
| `ZMAX` | 1.25×10⁻³ m | Chamber height (injection height) |

---

## Section 3 — Colloid and fluid properties (both)

| Parameter | Type | Typical value | Meaning |
|-----------|------|---------------|---------|
| `AP` | float (m) | 2×10⁻⁷–2×10⁻⁶ | Colloid radius |
| `RHOP` | float (kg/m³) | 1050 | Colloid density |
| `RHOW` | float (kg/m³) | 998 | Fluid (water) density |
| `VISC` | float (kg/m·s) | 9.98×10⁻⁴ | Fluid dynamic viscosity |
| `ER` | float (–) | 80 | Relative permittivity of fluid |
| `T` | float (K) | 293–298 | Absolute temperature |

**Derived quantities (both):**

| Variable | Formula | Meaning |
|----------|---------|---------|
| `MP` | (4/3)π AP³ RHOP | Particle mass |
| `VM` | (2/3)π AP³ RHOW | Added (virtual) mass |
| `M3` | 6π VISC AP | Stokes drag coefficient |
| `dTMRT` | MP / M3 | Momentum relaxation time — base unit for all timesteps |
| `ERE0` | ER × ε₀ | Absolute permittivity |
| `KAPPA` | √(e²·NIO·ZI²/ERE0·KB·T) | Inverse Debye screening length (m⁻¹) |

**Note on dTMRT and timestep scaling**: `dTMRT` scales as AP². Smaller colloids
have much smaller dTMRT and therefore much smaller absolute timesteps for the
same MULTB/MULTNS/MULTC values. For small colloids (AP ~ 500 nm) with no slip
(B=0), the near-surface zone may require millions of steps to traverse, making
MULTNS=2 impractically slow. Increase MULTNS to 10–25 for small colloids.
The Fortran runs the same number of steps but completes them ~100× faster.

---

## Section 3a — Simulation speed: traj_jet.py vs traj_hap.py

For the same colloid size and number of timesteps, `traj_jet.py` runs faster
per timestep than `traj_hap.py`. This is a consequence of the simpler geometry
modelled, not a code-quality difference. The four main contributors are:

**1. Flow field evaluation**
`traj_jet.py` calls `jet_ff()` — a rational polynomial with 14 coefficients
computed once before the trajectory loop. Each call is two polynomial
fraction evaluations. `traj_hap.py` calls `happel_ff()` — an analytic Stokes
solution requiring square-roots, trigonometric chains, and multiple divisions
at every timestep.

**2. Gravity decomposition**
`traj_jet.py` applies gravity as a scalar added to `UZ` (gravity always acts
in the Z direction on a flat plate). `traj_hap.py` calls `gravvect()` at every
step to decompose gravity into normal and tangential vector components relative
to the curved collector surface, requiring multiple dot-products per step.

**3. Velocity integration**
`traj_jet.py` updates three independent scalars (`UX`, `UY`, `UZ`).
`traj_hap.py` decomposes velocity into normal and tangential frames, updates
both separately, then recomposes into Cartesian coordinates — roughly double
the vector arithmetic per timestep.

**4. Heterodomain geometry**
`traj_jet.py` uses `hettrack()` on a flat surface — a 2D polar grid projection
with no coordinate rotation. `traj_hap.py` adds `_rotation_matrix()` and
`_transformation()` (quaternion-based 3D rotation) to project heterodomains
onto the tangent plane of a sphere. When heterodomains are active, this
geometry step is evaluated at every near-surface and contact timestep and
is the dominant cost for long near-surface residence.

**Summary table**

| Operation | traj_jet.py | traj_hap.py |
|-----------|-------------|-------------|
| Flow field | Polynomial, coeffs pre-computed | Analytic Stokes, computed every step |
| Gravity | Scalar, 1 addition | Vector decomposition, ~6 dot-products |
| Velocity integration | 3 scalar updates | Normal/tangential decomposition + recompose |
| Heterodomain geometry | 2D polar (flat) | 3D quaternion rotation (sphere) |
| Coordinate system | Cylindrical (R, Z) | Cartesian + spherical |

The performance gap grows when heterodomains and roughness are both active
(large near-surface step counts). For such cases, submit as a batch job
regardless of which code is used. See the convergence notes in Section 12
and the Convergence Speed section of `traj_attachment.md` for guidance on
MULTNS selection.

---

## Section 4 — Water chemistry and surface charge (both)

| Parameter | Type | Typical value | Meaning |
|-----------|------|---------------|---------|
| `IS` | float (mol/m³) | 1–100 | Ionic strength. Controls Debye length κ⁻¹ |
| `ZI` | float (–) | 1.0 | Electrolyte valence |
| `ZETAPST` | float (V) | ±0.03–±0.07 | Colloid zeta potential. **Opposite sign to ZETACST → favorable conditions** |
| `ZETACST` | float (V) | ±0.03–±0.07 | Collector zeta potential |

---

## Section 5 — Heterogeneity, collector surface (both)

| Parameter | Type | Typical value | Meaning |
|-----------|------|---------------|---------|
| `ZETAHET` | float (V) | opposite sign to ZETACST | Zeta potential of collector heterodomains |
| `HETMODE` | int | 1 or 9 | Heterodomains per tile. **1** = uniform single size; **9** = bimodal 1:8 (1 large + 8 medium) |
| `RHET0` | float (m) | 50–200×10⁻⁹ | Large heterodomain radius |
| `RHET1` | float (m) | 20–80×10⁻⁹ | Medium heterodomain radius (HETMODE=9 only) |
| `SCOV` | float (–) | 0–0.1 | Fractional surface coverage of heterodomains. **0 = no heterodomains** |

**Note**: HETMODE=5 (1:4 bimodal) and HETMODE=73 (trimodal) are not supported in the Python port. Use HETMODE=1 or 9 only.

---

## Section 5a — Heterodomain generation geometry (both)

This section explains how the collector and colloid heterodomain patterns are
generated and projected to compute AFRACT — the fraction of the Zone of
Influence (ZOI) overlapping attractive heterodomains.

### Zone of Influence (ZOI)

The ZOI is a circular disk on the collector surface centered at the point
closest to the colloid. Its radius is:

```
RZOI = sqrt(ACONT² + (2/KAPPA)·(AP + sqrt(AP² − ACONT²)))
```

where KAPPA is the inverse Debye length and ACONT is the current JKR contact
radius. In the bulk zone (no contact), ACONT=0 and RZOI simplifies to the
bulk ZOI radius:

```
RZOIBULK = 2·sqrt((1/KAPPA)·AP)
```

**Critical formula note**: The factor of 2 must be **outside** the square
root. The incorrect form `sqrt(2·(1/KAPPA)·AP)` gives a value ~1.41× too
small, causing nearly all colloid heterodomain projections to fall outside
their radial limit and AFRACT to be incorrectly zero throughout the
near-surface zone. Always verify RZOIBULK in the flux file header against
the expected value.

### Collector heterodomain generation (hettrack)

Collector heterodomains are placed on a tiled grid over the collector surface.
The grid is constructed as concentric rings of heterodomains:

- The number of rings `NRING` is derived from `NHET0` — the number of large
  heterodomains computed from `SCOV`, `RHET0`, and the collector area.
- Ring spacing `DTHETA` divides the collector surface uniformly.
- The colloid's angular position on the collector (THETA, PHI) is used to
  identify the nearest ring and snap to the closest heterodomain in that ring.
- For **HETMODE=1**: only the single large heterodomain (radius RHET0) nearest
  the colloid is returned.
- For **HETMODE=9**: the nearest large heterodomain plus 8 surrounding medium
  heterodomains (radius RHET1) at 1/8 tile spacing are returned. The medium
  domain offsets use J-dependent angular formulas that match the Fortran
  HETTRACK subroutine exactly.

The returned heterodomain positions are then transformed into the ZOI plane
coordinate frame via `hetc_transformation` (hap only — the jet geometry
performs this step implicitly since the collector is flat).

**PHIOFF alternation**: The ring phi offset alternates ±0.1×DPHI on odd/even
rings to prevent systematic alignment. PHI is snapped as
`DPHI·round((PHIP−PHIOFF)/DPHI) + PHIOFF` — not simply `round(PHIP/DPHI)·DPHI`.
This detail must match the Fortran exactly.

**NHETRING minimum**: The number of heterodomains per ring has a minimum of 3,
and DPHI is computed using the float ring count `NHRINGREAL` rather than the
integer `NHETRING`.

### Colloid heterodomain generation (hettrackp)

Colloid heterodomains are placed on the colloid surface using the same
ring-based tiling approach, but tiled over the full sphere:

- `NHETP0` large domains and (for HETMODEP=9) 8× as many medium domains per
  tile are distributed across `NRING` latitude rings, spaced `DTHETA = PI/(NRING−1)`.
- Each ring contains `NHETRING = round(2π·RRING/ARCL)` heterodomains, with a
  minimum of 1.
- For each heterodomain position on the colloid sphere, a projection onto the
  collector-facing ZOI plane is computed. The projection accounts for:
  - The angular offset `BETA` between the heterodomain and the colloid centre
  - The projected radius shrinking as `sqrt(RPRO0·RPRO0·cos(BETA))`
  - Domains in the upper hemisphere (facing away from the collector) or beyond
    the radial limit `RPL = RZOIBULK + RHETP0` are excluded (projection = 0)
- The surviving projections are collected into `M_PRO` (list of [x, y, r]
  triples in the colloid frame) and then rotated into the collector ZOI frame
  via `mpro_transformation` (hap) or used directly (jet, flat geometry).

**HETMODEP=9 medium domain offsets**: Medium domains use
`PHI offset = (j−2)·PI/4` for j=2..9, placing 8 domains evenly around the
large domain. This matches the Fortran HETTRACKP subroutine.

### Fractional area calculation (fractional_area)

Once collector heterodomains and colloid projections are in the same ZOI plane
frame, `fractional_area` computes the four non-overlapping area fractions:

| Fraction | Meaning |
|----------|---------|
| `AF_PZ` | ZOI area covered by colloid projections only |
| `AF_ZH` | ZOI area covered by collector heterodomains only |
| `AF_PZH` | ZOI area covered by both (triple overlap) |
| `AF_Z` | ZOI area covered by neither |

These are combined into `AFRACT = AF_PZ + AF_ZH − AF_PZH`, which is the
fraction of the ZOI with at least one attractive surface (heterodomain on
either colloid or collector). AFRACT then weights the four EDL force
components (collector plain / colloid het / collector het / both het) to give
the net `FEDL`.

### HETTYPE output variable

| Value | Meaning |
|-------|---------|
| 0 | No heterodomain overlap with ZOI |
| 1 | Large heterodomain overlap (k=0 in hettrack loop, HETMODE=1 or 9) |
| 2 | Medium heterodomain overlap (k>0, HETMODE=9 only) |
| 4 | Large AND medium overlap simultaneously |

### Geometry difference between hap and jet

In the jet geometry, the collector is a flat plate and the ZOI plane is simply
the horizontal plane at the collector surface. Heterodomain positions in
`hettrack` are already in this plane (2D: X, Y only), and colloid projections
from `hettrackp` are projected straight down. No coordinate rotation is needed.

In the hap geometry, the collector is a sphere and the ZOI plane is tangent to
the sphere at the point closest to the colloid. The orientation of this plane
changes as the colloid moves around the grain. Two transformation steps are
required:
- `hetc_transformation` — rotates collector heterodomain positions (in 3D
  spherical coordinates) into the ZOI plane frame using a quaternion rotation
  matrix defined by the colloid's angular position (THETA, PHI) on the grain.
- `mpro_transformation` — rotates colloid heterodomain projections (in colloid
  frame) into the same ZOI plane frame.

Both transformations use the same quaternion pipeline (`_rotation_matrix`,
`_transformation`). Once transformed, the 2D fractional area calculation
proceeds identically in both codes.

---

## Section 6 — Heterogeneity, colloid surface (both)

| Parameter | Type | Typical value | Meaning |
|-----------|------|---------------|---------|
| `ZETAHETP` | float (V) | — | Zeta potential of colloid heterodomains |
| `HETMODEP` | int | 1 or 9 | Colloid heterodomain pattern. **1** = uniform single size; **9** = bimodal 1:8 (1 large + 8 medium) |
| `RHETP0` | float (m) | — | Large colloid heterodomain radius |
| `RHETP1` | float (m) | — | Medium colloid heterodomain radius (HETMODEP=9 only) |
| `SCOVP` | float (–) | 0–0.1 | Fractional coverage of colloid heterodomains. **0 = uniform colloid** |

**Note**: HETMODEP=5 (1:4 bimodal) is not supported in the Python port. Use HETMODEP=1 or 9 only.

---

## Section 7 — Van der Waals forces (both)

| Parameter | Type | Typical value | Meaning |
|-----------|------|---------------|---------|
| `A132` | float (J) | 1×10⁻²¹–1×10⁻²⁰ | Combined Hamaker constant. Used only when VDWMODE=1 |
| `LAMBDAVDW` | float (m) | 50–200×10⁻⁹ | VDW retardation wavelength |
| `VDWMODE` | int | 1–4 | **1** = uncoated; **2** = coated colloid + coated collector; **3** = bare colloid + coated collector; **4** = coated colloid + bare collector |
| `A11, A22, A33` | float (J) | — | Hamaker constants: colloid core, collector core, fluid |
| `AC1C1, AC2C2` | float (J) | — | Hamaker constants of colloid coating (C1) and collector coating (C2) |
| `T1, T2` | float (m) | 0–50×10⁻⁹ | Coating thicknesses on colloid (T1) and collector (T2) |

**Geometry note**: traj_hap.py uses sphere-sphere VDW geometry (Gregory 1981);
traj_jet.py uses sphere-plate geometry. Both support all four VDWMODE options.

**VDWMODE=2 bugs fixed**: Two bugs were found and fixed in `force_vdw` VDWMODE=2:
term 3 denominator was `(lam+11.12*(H+T2))**2` (wrong) vs `lam+11.12*(H+T2)**2` (correct),
and term 4 log argument was `H/(H+2*T1+2*AP)` (wrong) vs `(H+T1)/(H+T1+2*AP)` (correct).
VDWMODE=1, 3, 4 are correct. Always verify against Fortran when porting to hap.

**LAMBDAVDW in find_hfric_hmin**: Must be passed to this function — was previously
hardcoded as 100nm, giving wrong HMIN when LAMBDAVDW ≠ 100nm.

---

## Section 8 — Lewis acid-base and steric forces (both)

| Parameter | Type | Typical value | Meaning |
|-----------|------|---------------|---------|
| `GAMMA0AB` | float (J/m²) | −0.03 to +0.03 | AB free energy at H0. **Negative → additional attraction** |
| `LAMBDAAB` | float (m) | 0.6–1.0×10⁻⁹ | AB decay length |
| `GAMMA0STE` | float (J/m²) | 0–0.05 | Steric repulsion energy density at H0 |
| `LAMBDASTE` | float (m) | 0.2–1.0×10⁻⁹ | Steric decay length |

---

## Section 9 — Surface roughness (both)

| Parameter | Type | Typical value | Meaning |
|-----------|------|---------------|---------|
| `B` | float (m) | 0–10×10⁻⁹ | Hydrodynamic slip length. Shifts HBAR = (H+B)/AP, reducing lubrication retardation at small H. **B=0 → full lubrication; B>0 → partial slip** |
| `RMODE` | int | 0–3 | **0** = smooth-smooth; **1** = rough colloid; **2** = rough collector; **3** = rough-rough |
| `ASP` | float (m) | 0–50×10⁻⁹ | Fine-scale asperity height |
| `ASP2` | float (m) | 0–50×10⁻⁹ | Coarse-scale asperity height (sets torque lever arm RLEV when > ACONT) |

**Performance note**: Combining nanoscale roughness (B > 0, RMODE > 0, ASP > 0)
with heterodomain coverage on both surfaces is computationally demanding in Python.
The heterodomain geometry is recalculated at every near-surface step, and with
complex roughness the particle may spend hundreds of thousands of steps in the
near-surface zone. Such runs should be submitted as batch jobs. The Fortran
reference code completes the same calculation ~100× faster.

---

## Section 10 — Deformation (JKR contact mechanics) (both)

| Parameter | Type | Typical value | Meaning |
|-----------|------|---------------|---------|
| `KINT` | float (N/m²) | 10⁸–10¹⁰ | Combined elastic modulus |
| `W132` | float (J/m²) | −0.001 to −0.1 | Work of adhesion. **Must be negative**. Determines ACONTMAX |
| `BETA` | float (–) | 0.5–1.0 | Contact radius scaling. < 1.0 for attachment, 1.0 for detachment |

**Derived deformation variables:**

| Variable | Meaning |
|----------|---------|
| `ACONTMAX` | Maximum JKR contact radius = (−6πW132·AP²/KINT)^(1/3) |
| `DELTAMAX` | Maximum deformation = AP − √(AP²−ACONTMAX²) |
| `ACONT` | Current contact radius |
| `DELTA` | Current deformation depth |
| `RLEV` | Torque lever arm = max(AP·ASP2/(AP+ASP2), ACONT) |
| `ASTE` | Steric interaction radius (accounts for deformation) |

---

## Section 11 — Diffusion and gravity (both)

| Parameter | Code | Type | Typical value | Meaning |
|-----------|------|------|---------------|---------|
| `DIFFSCALE` | both | float (–) | 0.0 or 1.35 | Brownian diffusion multiplier. **0 = no diffusion**. 1.35 is calibrated value |
| `GRAVFACT` | both | float (–) | 0.0 or 1.0 | Gravity multiplier. **0 = neutrally buoyant** |
| `CBGRAV` | hap | int | 1–4 | Gravity direction: **1** = with flow (−Z); **2** = against (+Z); **3** = orthogonal (−X); **4** = orthogonal (+X). Also controls exit condition |

**Note (jet)**: The jet code uses `GRAVFACT` as −1.0 (concurrent) or +1.0
(countercurrent) rather than a direction integer. Gravity always acts in the
Z direction for the jet geometry.

---

## Section 12 — Timestep and slow-motion (both)

| Parameter | Type | Typical value | Meaning |
|-----------|------|---------------|---------|
| `MULTB` | float (–) | 100–1000 | Bulk timestep multiplier. dT = MULTB × dTMRT |
| `MULTNS` | float (–) | 2–25 | Near-surface timestep multiplier. **See convergence note below** |
| `MULTC` | float (–) | 0.01–0.1 | Contact zone timestep multiplier. **See note below** |
| `DFACTNS` | float (–) | 1×10⁻⁴–1×10⁻⁶ | Near-surface slow-motion threshold (ATTACHK=5) |
| `DFACTC` | float (–) | 1×10⁻⁵–1×10⁻⁷ | Contact slow-motion threshold (ATTACHK=4) |

**Convergence note for MULTNS**: The absolute near-surface timestep is
`MULTNS × dTMRT = MULTNS × MP/M3`, which scales as AP². For small colloids
(AP ~ 500 nm) with B=0, MULTNS=2 can require ~1.7 million steps to traverse
from HNS to HFRIC, taking 20–70 minutes per particle in Python. The Fortran
completes the same steps ~100× faster. Recommended values by colloid size:

| AP | Recommended MULTNS |
|----|-------------------|
| ≥ 1 µm | 2–10 |
| 500 nm | 10–25 |
| < 500 nm | 25–50 |

**Energy barrier caution for MULTNS (unfavorable conditions)**: Under
unfavorable conditions, the normal displacement per step must remain well
below the Debye length (~4 nm at IS=6 mol/m³). If MULTNS is too large,
a single step could carry the particle through the energy barrier peak
without resolving the repulsion — effectively numerical tunneling. Validate
by checking that unfavorable particles produce ATTACHK=1/3/5 outcomes, not
unexpected ATTACHK=2/4 attachment.

**Note on MULTC**: Born repulsion varies as H⁻⁸ — an extremely steep gradient
near H0=0.158nm. The governing criterion is whether the normal displacement
per contact step (`MULTC × dTMRT × UN`) is small relative to H0. Because
lubrication retardation strongly damps UN as H→0, the actual displacement
per step is much smaller than the bulk equivalent.

Start with MULTC=0.01 as a conservative default. MULTC=0.1 has been validated
for AP=2.2µm under favorable/heterodomain conditions with no ATTACHK=6 crashes
and physically correct results. If ATTACHK=6 crashes are observed, reduce MULTC.
The contact zone is not a performance bottleneck — do not increase MULTC solely
to improve run speed.

---

## Section 13 — Output control (both)

| Parameter | Type | Typical value | Meaning |
|-----------|------|---------------|---------|
| `NOUT` | int | 10–10000 | Trajectory snapshot interval (steps). In production runs (NPART≥10) trajectory files are not written. In diagnostic/comparison runs (NPART<10) trajectory files are written every NOUT steps |
| `PRINTMAX` | int | 10000–50000 | Maximum rows in trajectory output buffer |

**Trajectory file production**: Both `traj_hap.py` and `traj_jet.py` write
trajectory files when `NPART < 10`. This threshold identifies diagnostic and
comparison runs. Production runs (NPART≥10) write flux files only.

**For Fortran vs Python comparison runs**:
- Set `DIFFSCALE=0` (eliminates random divergence), `NPART=1`, `NOUT=10`
- Use `job_slurm_hap_compare` (hap) which calls `traj_hap.py` directly,
  passing XINIT/YINIT as arguments 4 and 5, bypassing the `submit` dispatcher
- The Fortran binary (`TRAJ-HAP.for`) is called via `haphet.csh` from `job_slurm`
- Trajectory files are written to DATADIR and copied back by `cp *.OUT $DATADIR/`

**Porting note — FUN hydrodynamic coefficients**: The Goldman-Cox-Brenner
correction factor coefficients (A1-E4) must be copied directly from the
Fortran DATA statements. Using values from external literature sources —
even from the same cited papers — risks getting a different coefficient set.
The correct values (Masliyah & Bhattacharjee 2005 / GCB 1967) are:
```
A1=0.9267  B1=-0.3990  C1=0.1487  D1=-0.601   E1=1.202
A2=0.5695  B2=1.355    C2=1.36    D2=0.875    E2=0.525
A3=0.2803  B3=-0.1430  C3=1.472   D3=-0.6772  E3=2.765
A4=0.2607  B4=-0.3015  C4=0.9006  D4=-0.5942  E4=1.292
```

---

## Key internal state variables (both)

| Variable | Meaning |
|----------|---------|
| `ATTACHK` | Outcome: 0=active, 1=exit, 2=attached (sink/arrest), 3=remaining, 4=attached (contact slow-motion), 5=retained (near-surface slow-motion), 6=crashed |
| `HFLAG` | Zone: 1=bulk, 2=near-surface, 3=contact |
| `H` | Surface-to-surface separation (m), corrected for roughness and deformation |
| `HFRIC` | Contact zone boundary — separation where short-range forces reach 0.01% of H0 value |
| `HMIN` | Energy minimum separation (Born repulsion balances all attractions) |
| `IREF1` | Near-surface slow-motion step counter (resets on zone exit) |
| `IREF2` | Contact slow-motion step counter (resets on zone exit) |
| `ARRESTFLAG` | 1 if tangential velocity clamped to zero this step; 0 otherwise |
| `AFRACT` | Fraction of ZOI overlapping attractive heterodomain. −1.0 when inactive |
| `RZOI` | Zone of influence radius |
| `HAVE` | Time-averaged separation during near-surface residence |
| `NSVEL` | Average near-surface tangential speed (arc-length / time in NS) |
| `TBULK / TNEAR / TFRIC` | Cumulative time in bulk / near-surface / contact zones |
| `NSVISIT / FRICVISIT` | Visit counts for near-surface / contact zones |
| `UN / UT` | Normal and tangential colloid velocity components (m/s) |
| `VN / VT` | Normal and tangential fluid velocity components (m/s) |
| `FUN1–FUN4` | Hydrodynamic correction factors (Goldman et al. 1967) |
| `OMEGA` | Colloid angular velocity (rad/s) |
| `PTIMEF` | Absolute simulation time (s) |
| `ETIME` | Time since particle entered near-surface zone (s) |

---

## Output file reference

### traj_hap.py

| File | Contents |
|------|----------|
| `HAPHETFLUXEX.OUT` | One row per exited particle (ATTACHK=1) |
| `HAPHETFLUXATT.OUT` | One row per attached particle (ATTACHK=2,4,6) |
| `HAPHETFLUXREM.OUT` | One row per remaining/retained particle (ATTACHK=3,5) |

### traj_jet.py

| File | Contents |
|------|----------|
| `JETFLUXEX.OUT` | One row per exited particle (ATTACHK=1) |
| `JETFLUXATT.OUT` | One row per attached particle (ATTACHK=2,4,6) |
| `JETFLUXREM.OUT` | One row per remaining/retained particle (ATTACHK=3,5) |

### Both codes (CLUSTER=1 mode)

Per-particle flux files named `HAPHETFLUXEX.N.OUT` / `JETFLUXEX.N.OUT` etc.,
where N is the particle index. Concatenated into consolidated files by
`hap.csh` / `jet.csh` after all workers complete. Header line count is
detected dynamically — no hardcoded values needed.

**Note**: Trajectory files, per-particle log files, status files, and lock
files are not produced by the current production code. All output is
contained in the three flux files above.

### Monitoring a running job (both codes, CLUSTER=1)

Three sources of information are available during a run:

**master.out** (scratch directory) — written progressively by `submit`:
```bash
cat $WORKDIR/master.out
```
Shows which particles have been dispatched, are running, or have completed.

**Per-particle flux files** (scratch directory) — appear as each particle
completes:
```bash
ls -la $WORKDIR/JETFLUX*.OUT       # jet — shows completed particles
ls -la $WORKDIR/HAPHETFLUX*.OUT    # hap — shows completed particles
```

**slurm output file** (`slurm-XXXXXXX.out`) — progress lines every 10,000
steps for particles still running:
```
step=    10000  H=1.234E-07  HFLAG=2  R=2.456E-04  AFRACT=0.4595
```

After the job completes, `jet.csh` / `hap.csh` concatenates per-particle
files into consolidated `JETFLUX*.OUT` / `HAPHETFLUX*.OUT` in DATADIR.
