# xDLVO — Extended DLVO Interaction Calculator

Calculates extended DLVO (xDLVO) colloid-surface interaction energy and force
profiles as a function of separation distance. Supports sphere-plate and
sphere-sphere geometries, layered and non-layered surfaces, smooth and rough
surfaces, and surfaces with nanoscale charge heterogeneity (heterodomains).

---

## What This Code Does

The xDLVO module computes the profile of superimposed colloid-surface
interaction forces and energies as a function of separation distance H,
implementing the following interactions:

| Interaction | Expression | Notes |
|-------------|-----------|-------|
| **Van der Waals (VDW)** | Gregory (1981) retarded | 4 modes: uncoated, both coated, collector coated, colloid coated |
| **Electric double layer (EDL)** | Lin & Wiesner (2012) | Poisson-Boltzmann; sphere-plate or sphere-sphere |
| **Lewis acid-base (LAB)** | Wood & Rehmann (2014) | Geometric correction for sphere-sphere vs sphere-plate |
| **Steric/hydration repulsion** | Butt et al. (2005) | Exponential decay |
| **Born repulsion** | Ruckenstein & Prieve (1976) | Defines equilibrium contact separation (~0.158 nm) |

Default parameter values are provided for polystyrene latex colloids
interacting with silica across water — the most commonly used experimental
system in the Johnson and Pazmiño research groups.

The xDLVO module is designed to work in tandem with the trajectory codes —
output informs selection of surface interaction parameters (A₁₃₂, ζ potentials,
LAB parameters, steric parameters, asperity heights) for use in pore-scale
trajectory simulations.

---

## Platforms

| Platform | Notes |
|----------|-------|
| **Matlab (GUI)** | Interactive GUI with real-time plots; recommended starting point |
| **Excel** | Spreadsheet implementation; rapid parameter exploration |
| **Python** | Scripting and batch calculations |

📺 Video: [xDLVO module walkthrough](https://youtu.be/rnKLHnE-vBo)

---

## Key Capabilities

### Geometry
- **Sphere-plate** — appropriate for flat collector surfaces (impinging jet,
  parallel plate)
- **Sphere-sphere** — appropriate for granular porous media (Happel, cubic
  packing); uses effective radius a_eff = AP·AG/(AP+AG)

### VDW Coating Modes (VDWMODE)
| Mode | Description |
|------|-------------|
| 1 | Uncoated colloid and collector — uses combined Hamaker constant A₁₃₂ |
| 2 | Both colloid and collector coated |
| 3 | Collector coated only |
| 4 | Colloid coated only |

For coated systems, individual Hamaker constants (A11, A22, A33, AC1C1, AC2C2)
and coating thicknesses (T1, T2) replace A₁₃₂.

### Hamaker Constant Calculation
The code optionally calculates individual Hamaker constants from permittivity
(ε) and refractive index (n) values using the Israelachvili (2011) expressions,
or accepts user-supplied values.

### Roughness
Roughness reduces both VDW and EDL interactions by reducing the effective
radius of curvature at the point of closest approach. Two layers of interaction
are computed — one for asperity-to-surface contact and one for the equivalent
smooth surface separation. Roughness does not flip repulsive interactions to
attractive; it reduces all interactions.

### Nanoscale Heterodomain
Calculates the interaction profile for a heterodomain of opposite charge
centered within the ZOI, demonstrating the transition from net repulsive to
net attractive as heterodomain size or ionic strength increases. This directly
connects to the DRNH system in the trajectory codes.

---

## Quick Start

### Matlab GUI
1. Run as Administrator
2. Default parameters correspond to CML microspheres on silica in water
3. Start with smooth surfaces (no roughness) under favorable conditions
   to confirm the primary minimum, then introduce unfavorable conditions
   and heterodomain to explore the repulsive barrier and ZOI overlap

### Python
```bash
cd nano_scale/xdlvo/python/
# Edit input parameters in xdlvo_params.py
python3 xdlvo.py
```

### Excel
Open `xdlvo/excel/xDLVO.xlsx` and edit the parameter cells in the input sheet.
Results and plots update automatically.

---

## Key Input Parameters

| Parameter | Symbol | Units | Notes |
|-----------|--------|-------|-------|
| Colloid radius | AP | m | |
| Grain radius | AG | m | Sphere-sphere only |
| Colloid zeta potential | ZETAP | V | Negative for most environmental colloids |
| Collector zeta potential | ZETAC | V | Opposite sign → favorable |
| Ionic strength | IS | mol/m³ | Controls Debye length |
| Electrolyte valence | ZI | — | 1 for NaCl, 2 for CaCl₂ |
| Combined Hamaker constant | A132 | J | VDWMODE=1 only |
| VDW wavelength | LAMBDAVDW | m | Typically ~100 nm |
| LAB energy at contact | GAMMA0AB | J/m² | |
| LAB decay length | LAMBDAAB | m | |
| Steric energy at contact | GAMMA0STE | J/m² | Set to 0 if no coating |
| Steric decay length | LAMBDASTE | m | |
| Asperity height | ASP | m | Set to 0 for smooth surfaces |
| Temperature | T | K | |

---

## Output

The code produces interaction energy (ΔG) and force (F) profiles as a function
of separation distance H, with individual contributions from each interaction
plotted separately and superimposed. Key features identified in the output:

- **Primary minimum** depth and location (contact adhesion force)
- **Repulsive barrier** height (under unfavorable conditions)
- **Secondary minimum** depth and location
- **ZOI radius** for EDL and LAB interactions

---

## Relationship to Trajectory Codes

The xDLVO and trajectory codes share identical force expressions. Parameters
set in xDLVO carry directly into the trajectory input files:

| xDLVO output | Trajectory input parameter |
|-------------|---------------------------|
| A₁₃₂ value | A132 |
| ζ potentials | ZETAPST, ZETACST |
| LAB parameters | GAMMA0AB, LAMBDAAB |
| Steric parameters | GAMMA0STE, LAMBDASTE |
| Asperity height | ASP, ASP2 |
| Hamaker constants | A11, A22, A33, AC1C1, AC2C2, T1, T2 |

---

## References

- Johnson, W.P. and Pazmiño, E.F. (2023). *Colloid (Nano- and Micro-Particle)
  Transport and Surface Interaction in Groundwater*. The Groundwater Project.
  https://doi.org/10.21083/978-1-77470-070-9 — Section 4 (freely available)

- Ron, C. and Johnson, W.P. (2020). Complementary colloid and collector
  nanoscale heterogeneity explains microparticle retention under unfavorable
  conditions. *Environmental Science: Nano*, 7, 4010–4021.
  https://doi.org/10.1039/D0EN00815J

- Elimelech, M. and O'Melia, C.R. (1990). Kinetics of deposition of colloidal
  particles in porous media. *Environmental Science & Technology*, 24(10),
  1528–1536.

- Pazmino, E., Trauscht, J., and Johnson, W.P. (2014). Release of colloids
  from primary minimum contact under unfavorable conditions by perturbations
  in ionic strength and flow rate. *Environmental Science & Technology*,
  48(16), 9227–9235. https://doi.org/10.1021/es502503y

- Yang, Y., Yuan, W., Johnson, W.P., Pazmino, E., Yuan, L., and You, Z.
  (2025). AFM-measured adhesion: explaining trends with temperature and ionic
  strength, and variance around mean. *Colloids and Surfaces A*, 137276.
  https://doi.org/10.1016/j.colsurfa.2025.137276

Full reference list: [`docs/references.md`](../../docs/references.md)
