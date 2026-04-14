# Parti-Suite

**Particle Trajectory and Continuum Upscaling Colloid Transport Codes**

W.P. Johnson and E.F. Pazmiño Research Groups  
University of Utah, Department of Geology & Geophysics  
Escuela Politécnica Nacional, Department of Extractive Metallurgy  

william.johnson@utah.edu · eddy.pazmino@epn.edu.ec

---

## Overview

Parti-Suite is a collection of open-source codes for simulating the transport and surface interaction of colloidal particles (nano- to micro-scale spheres) in groundwater and related systems. The suite spans three physical scales — nanoscale surface interactions, pore-scale particle trajectories, and continuum-scale transport — reflecting the hierarchy of processes that governs colloid behavior in granular porous media.

The theoretical and experimental foundations of Parti-Suite are described in:

> Johnson, W.P. and Pazmiño, E.F. (2023). *Colloid (Nano- and Micro-Particle) Transport and Surface Interaction in Groundwater*. The Groundwater Project, Guelph, Ontario, Canada. [https://doi.org/10.21083/978-1-77470-070-9](https://doi.org/10.21083/978-1-77470-070-9) — **freely available.**

An introductory video overview of Parti-Suite is available on YouTube: [Parti-Suite Overview](https://youtu.be/VexeneXY8hE)

---

## Scientific Background

The transport of colloids in granular porous media is governed by processes operating across a wide range of scales (Johnson and Pazmiño, 2023):

- **Nanoscale** — electrostatic double-layer, van der Waals, Lewis acid-base, steric, and Born repulsion forces act between colloid and grain surfaces, determining whether a colloid that contacts a surface will attach or be repelled.
- **Pore scale** — fluid drag, Brownian diffusion, gravity, and surface forces combine to govern individual colloid trajectories through the flow field around a collector grain. The outcome for a population of colloids — collector efficiency, attachment efficiency, residence time distributions — emerges from these trajectories.
- **Continuum scale** — pore-scale outcomes are upscaled to rate coefficients that govern breakthrough-elution concentration histories and profiles of retained colloids as a function of distance from source in laboratory columns and field settings.

Under environmentally typical conditions, both colloids and grain surfaces carry like (negative) charge, creating a repulsive energy barrier to attachment. Attachment nonetheless occurs via nanoscale zones of opposite charge (heterodomains) on grain surfaces. Parti-Suite explicitly represents this discrete representative nanoscale heterogeneity (DRNH) across all three scales, providing mechanistic prediction of colloid transport under both favorable (opposite-charge) and unfavorable (like-charge) conditions.

---

## Suite Structure

The suite is organized by physical scale, reflecting the natural workflow from nanoscale characterization through pore-scale simulation to continuum-scale prediction.

```
parti-suite/
├── nano_scale/                  Nanoscale colloid-surface interactions
│   ├── xdlvo/                   Extended DLVO interaction profiles
│   └── afm_force_volume/        AFM colloidal probe force-volume simulation
│
├── pore_scale/                  Pore-scale trajectory simulation
│   ├── trajectory/              Mechanistic force and torque balance
│   │   ├── happel/              Happel sphere-in-cell (Fortran, Matlab, Python)
│   │   ├── impinging_jet/       Impinging jet (Fortran, Python)
│   │   ├── parallel_plate/      Parallel plate (Fortran)
│   │   ├── dense_cubic_packing/ Dense cubic packing (Fortran)
│   │   └── hemisphere_in_cell/  Hemisphere-in-cell (Fortran)
│   └── correlation_equations/   Favorable-condition collector efficiency
│
└── continuum_scale/             Continuum-scale transport
    ├── upscale/                 Upscaling & inversion (Matlab)
    └── interception_history/    Forward prediction — Interception History (Excel)
```

---

## Platforms

| Platform | Used in |
|----------|---------|
| **Matlab** (with GUI) | xDLVO, AFM force-volume, Happel trajectory, correlation equations, upscaling & inversion. GUIs provide visualization and are recommended for learning and parameter exploration. |
| **Fortran** (parallel) | All trajectory geometries. Supports parallelized simulation of large particle populations (hundreds to thousands). |
| **Python** (parallel) | Happel and impinging jet trajectories, xDLVO, AFM force-volume, correlation equations. Ported from validated Fortran originals. Designed for easy parallelization via SLURM. |
| **Excel** | xDLVO, correlation equations, Interception History forward prediction. |

The Matlab codes with GUIs are the recommended starting point for new users — they provide immediate visualization of trajectories, forces, and outputs, and are well suited for learning the physics and exploring parameter space with populations of tens to hundreds of particles. The Fortran and Python codes support production runs with larger populations and are recommended once the user is familiar with the physics and input parameters.

---

## Modules

### Nanoscale — `nano_scale/`

**xDLVO** calculates extended DLVO colloid-surface interaction energy and force profiles for sphere-plate and sphere-sphere geometries, layered and non-layered surfaces, smooth and rough surfaces, and surfaces with nanoscale charge heterogeneity. Available in Excel, Matlab, and Python. Video: [xDLVO](https://youtu.be/rnKLHnE-vBo)

**AFM force-volume simulation** simulates AFM colloidal probe force-volume measurements over a surface with user-specified heterodomain size and coverage, reproducing the variance in measured adhesion forces that arises from variable overlap between the zone of colloid-surface interaction (ZOI) and heterodomains. Available in Matlab and Python.

---

### Pore Scale — `pore_scale/`

**Trajectory codes** simulate individual colloid trajectories under full force and torque balance in the flow field of a specified collector geometry. At each timestep, hydrodynamic drag (with Goldman-Cox-Brenner lubrication corrections), Brownian diffusion, van der Waals attraction, electrostatic double-layer forces, Lewis acid-base and steric repulsion, Born contact repulsion, gravity, and lift are computed and integrated forward in time. JKR contact mechanics govern attachment and detachment. Surface chemical heterogeneity (DRNH) is supported on both collector and colloid surfaces.

Collector geometries available:

| Geometry | Platforms | Notes |
|----------|-----------|-------|
| **Happel sphere-in-cell** | Fortran, Matlab (GUI), Python | Analytical flow field; represents any porosity; recommended starting geometry. Full functionality including heterogeneity, roughness, and detachment. |
| **Impinging jet** | Fortran, Python | Flat collector, radial stagnation flow; directly comparable to laboratory deposition experiments. Full functionality. |
| **Parallel plate** | Fortran | Flat collector, channel flow; gravity-driven longitudinal transport. Full functionality. |
| **Dense cubic packing** | Fortran | Stackable geometry with grain-to-grain contacts; fixed porosity. Heterogeneity not yet implemented. |
| **Hemisphere-in-cell** | Fortran | Grain-to-grain contacts, numerical flow field. Partial functionality. |
| **Rod-shaped colloids** | Fortran | Built on Happel geometry; requires explicit rotational dynamics. |

Videos (Happel geometry): [GUI Introduction](https://youtu.be/tOQ6gz2bI2E) · [Favorable conditions](https://youtu.be/kDuP98YLFow) · [Collector efficiencies](https://youtu.be/UBFmm3_hjm4) · [Unfavorable conditions](https://youtu.be/iONHPUl8mkM) · [Perturbation/detachment](https://youtu.be/GjOIg4Fb-_I)

**Correlation equations** calculate favorable-condition collector efficiency using published correlation equations from multiple authors, allowing rapid evaluation of collector efficiency across parameter ranges without running full trajectory simulations. Available in Excel, Matlab, and Python.

---

### Continuum Scale — `continuum_scale/`

**Upscale** (Matlab) reads trajectory simulation output from the Happel sphere-in-cell code and upscales pore-scale residence time distributions to continuum-scale rate coefficients, following the Interception History framework (Johnson et al., 2018). It then runs Lagrangian continuum-scale transport simulations to predict breakthrough-elution concentration histories and profiles of retained colloids as a function of distance from source, under both implicit and explicit representations of the near-surface fluid domain. Videos: [Upscale Background](https://youtu.be/HqJTNf7MO2k) · [Upscale How-To](https://youtu.be/IhZN15s9AT4)

**Interception History** (Excel) implements forward prediction of colloid transport data from pore-scale parameters using the Interception History framework, providing a rapid continuum-scale prediction tool that complements the full upscaling workflow.

---

## Recommended Workflow

```
1.  nano_scale/xdlvo          Characterize colloid-surface interaction energy
                               profile; identify energy barrier and secondary
                               minimum for your system.

2.  pore_scale/trajectory     Simulate colloid trajectories in your collector
      /happel  (Matlab GUI)    geometry. Start with favorable conditions to
                               establish collector efficiency. Then introduce
                               heterogeneity (SCOV) to match observed
                               attachment under unfavorable conditions.

3.  continuum_scale/upscale   Feed Happel trajectory output into Upscale to
                               obtain rate coefficients and predict
                               breakthrough-elution histories and retained
                               profiles at the column/field scale.
```

The xDLVO and Happel trajectory codes are designed to work together — xDLVO output informs selection of surface interaction parameters for the trajectory codes.

---

## Getting Started

Each module has its own README with installation instructions, input file descriptions, and example runs. New users should begin with:

1. Watch the [Parti-Suite Overview](https://youtu.be/VexeneXY8hE) video.
2. Read the [companion textbook](https://doi.org/10.21083/978-1-77470-070-9) (freely available) for theoretical background.
3. Start with the **Matlab GUI codes** — begin with `nano_scale/xdlvo/matlab/` and `pore_scale/trajectory/happel/matlab/`.
4. Use the `docs/` folder for the full parameter glossary, attachment criteria reference, and trajectory loop flowchart.

We suggest beginning simulations with larger colloids (> 1 µm) and higher fluid velocities (> 10 m/day) under favorable conditions for rapid familiarization, then adjusting parameters as desired.

---

## Documentation

| Document | Contents |
|----------|----------|
| [User Manual](docs/user_manual.md) | Setup, running, monitoring, and interpreting trajectory simulation results |
| [Parameter Glossary](docs/traj_glossary.md) | Every input parameter with units, typical values, and physical meaning |
| [Attachment Criteria](docs/traj_attachment.md) | Outcome codes, zone logic, slow-motion criteria |
| [Trajectory Flowchart](docs/traj_flowchart.html) | Visual overview of the trajectory loop (open in browser) |
| [Physics Background](docs/physics_background.md) | xDLVO theory, DRNH, force and torque balance, Interception History framework |
| [References](docs/references.md) | Full citation list |

---

## Validation

The Python trajectory codes (`traj_hap.py`, `traj_jet.py`) have been validated against the original Fortran binaries with step-by-step trajectory comparison. Agreement across all simulation zones is better than 0.6% for all key variables, with both codes reproducing the same physical outcome (attachment location, outcome code) as the Fortran reference.

---

## Citation

If you use Parti-Suite in published work, please cite the companion textbook and the relevant peer-reviewed publications listed in [docs/references.md](docs/references.md).

> Johnson, W.P. and Pazmiño, E.F. (2023). *Colloid (Nano- and Micro-Particle) Transport and Surface Interaction in Groundwater*. The Groundwater Project. https://doi.org/10.21083/978-1-77470-070-9

*Additional citation information to be added on publication of source code release.*

---

## License

*License to be confirmed.*

---

## Contact

William P. Johnson — william.johnson@utah.edu  
Eddy F. Pazmiño — eddy.pazmino@epn.edu.ec  
University of Utah, Department of Geology & Geophysics
