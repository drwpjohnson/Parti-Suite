# AFM Force-Volume Simulation

Simulates AFM colloidal probe force-volume measurements over a surface with
user-specified nanoscale heterodomain size and surface coverage. Reproduces
the variance in measured adhesion forces that arises from variable overlap
between the zone of colloid-surface interaction (ZOI) and heterodomains across
a raster grid of probe locations.

---

## What This Code Does

In AFM force-volume measurements, a colloid-tipped probe is rastered across
a surface at a user-specified grid spacing, recording the adhesion force at
each location. On surfaces with nanoscale charge heterogeneity (heterodomains),
the measured adhesion force varies from location to location depending on
whether the ZOI at each probe position overlaps with one or more heterodomains.

This module simulates that measurement process:

1. Places heterodomains on a surface at user-specified size (RHET) and
   fractional surface coverage (SCOV) with regular spacing
2. Rastering a colloidal probe across the surface at a user-specified grid
   spacing (total number of measurement points, e.g. 7×7 or 9×9)
3. At each probe location, calculates the ZOI radius from colloid size and
   ionic strength
4. Determines the fractional ZOI overlap with heterodomains (AFRACT)
5. Computes the xDLVO adhesion force at each probe location based on AFRACT
6. Produces adhesion force maps and histograms

The simulated variance in adhesion forces arises from the same mechanism that
drives colloid-by-colloid variability in attachment in the trajectory codes —
variance in ZOI-heterodomain overlap. This provides a direct connection between
AFM force-volume measurements and pore-scale colloid transport behavior.

---

## Platforms

| Platform | Notes |
|----------|-------|
| **Matlab (GUI)** | Interactive GUI with force maps and histograms |
| **Python** | Scripting and batch calculations |

---

## Key Capabilities

- User-specified heterodomain radius (RHET), surface coverage (SCOV), and
  raster grid dimensions (N×N measurement points)
- ZOI radius calculated from colloid size (AP) and ionic strength (IS)
- Produces adhesion force histograms comparable to experimental AFM
  force-volume data
- Demonstrates how raster spacing interacts with heterodomain size to produce
  variance in measured forces — finer raster spacing increases the number of
  probe positions that partially overlap heterodomains, increasing variance
- Force maps showing spatial distribution of adhesion force across the surface

---

## Key Input Parameters

| Parameter | Meaning | Notes |
|-----------|---------|-------|
| AP | Colloid (probe) radius (m) | Sets ZOI size |
| IS | Ionic strength (mol/m³) | Controls ZOI radius via Debye length |
| RHET | Heterodomain radius (m) | Nanoscale attractive zone size |
| SCOV | Fractional surface coverage by heterodomains | 0–1 |
| N | Grid dimension (N×N raster points) | e.g. 7 for 7×7 = 49 locations |
| Raster spacing | Distance between probe locations (m) | Set by scan area / N |

All xDLVO surface interaction parameters (A₁₃₂, ζ potentials, LAB parameters)
are shared with the xDLVO module — see [`xdlvo/README.md`](../xdlvo/README.md).

---

## Relationship to xDLVO and Trajectory Codes

The AFM force-volume module uses the same xDLVO force expressions as the
xDLVO module and the trajectory codes. The ZOI-heterodomain overlap (AFRACT)
calculated here is identical in concept to AFRACT computed at each near-surface
timestep in the trajectory simulations. This makes the AFM module a useful
tool for:

- Validating heterodomain parameters (RHET, SCOV) against experimental
  AFM force-volume data before running trajectory simulations
- Understanding how ZOI size (colloid size and IS) interacts with heterodomain
  geometry to produce observed variance in adhesion forces
- Connecting laboratory AFM measurements to pore-scale transport predictions

---

## Example

For a 5 µm radius colloid probe at IS = 0.1 M (40°C), the ZOI radius is
~201 nm. With heterodomains of 134 nm radius at 40% surface coverage:

- A 7×7 raster (0.833 µm spacing) and a 9×9 raster (0.625 µm spacing) produce
  different patterns of ZOI-heterodomain overlap
- The resulting adhesion force histograms reproduce the variance observed in
  experimental force-volume measurements on the same system
- Finer raster spacing increases probe positions that partially overlap
  heterodomains, shifting the distribution

See the figures in `docs/figures/` for example output from this system
(Ron and Johnson, 2020).

---

## References

- Johnson, W.P. and Pazmiño, E.F. (2023). *Colloid (Nano- and Micro-Particle)
  Transport and Surface Interaction in Groundwater*. The Groundwater Project.
  https://doi.org/10.21083/978-1-77470-070-9 (freely available)

- Ron, C. and Johnson, W.P. (2020). Complementary colloid and collector
  nanoscale heterogeneity explains microparticle retention under unfavorable
  conditions. *Environmental Science: Nano*, 7, 4010–4021.
  https://doi.org/10.1039/D0EN00815J

- Yang, Y., Yuan, W., Johnson, W.P., Pazmino, E., Yuan, L., and You, Z.
  (2025). AFM-measured adhesion: explaining trends with temperature and ionic
  strength, and variance around mean. *Colloids and Surfaces A*, 137276.
  https://doi.org/10.1016/j.colsurfa.2025.137276

- Elimelech, M. and O'Melia, C.R. (1990). Kinetics of deposition of colloidal
  particles in porous media. *Environmental Science & Technology*, 24(10),
  1528–1536.

- Pazmino, E., Trauscht, J., and Johnson, W.P. (2014). Release of colloids
  from primary minimum contact under unfavorable conditions by perturbations
  in ionic strength and flow rate. *Environmental Science & Technology*,
  48(16), 9227–9235. https://doi.org/10.1021/es502503y

Full reference list: [`docs/references.md`](../../docs/references.md)
