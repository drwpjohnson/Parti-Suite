# Upscale — Interception History Upscaling and Inversion

Reads pore-scale trajectory simulation output from the Happel sphere-in-cell
code and upscales residence time distributions to continuum-scale rate
coefficients via the Interception History framework. Runs Lagrangian
continuum-scale transport simulations to predict breakthrough-elution
concentration histories (BTCs) and profiles of retained colloids as a function
of distance from source (RCPs).

---

## What This Code Does

UpscaleContinuum implements the full Interception History upscaling workflow
(Johnson et al., 2018; Johnson, 2020) in a single Matlab GUI:

1. **Reads UPFLUX files** — user-prepared Excel files containing favorable and
   unfavorable Traj-Hap flux data
2. **Determines near-surface velocity (v₂)** from near-surface colloid velocity
   data in the trajectory output
3. **Constructs residence time histograms** — overlapping distributions for
   favorable and unfavorable attachment that define α₁ and α₂
4. **Calculates pore-scale efficiencies** — η, α₁, α₂, α_RFSZ, α_reent
5. **Upscales to rate coefficients** — k_f, k_f2/k_ns, k_f2* using
   user-specified grain-to-grain transfer efficiencies and characteristic
   velocity
6. **Runs continuum-scale Lagrangian simulations** — predicts BTCs and RCPs
   under implicit and explicit near-surface representations

---

## Platform

| Platform | Notes |
|----------|-------|
| **Matlab (GUI)** | Only available platform |

📺 Videos: [Upscale Background](https://youtu.be/HqJTNf7MO2k) ·
[Upscale How-To](https://youtu.be/IhZN15s9AT4)

---

## Preparing UPFLUX Input Files

UpscaleContinuum reads a user-prepared Excel file (e.g., `UPFLUX.xls`)
containing four worksheets in the following strict order:

| Worksheet | Contents |
|-----------|----------|
| **FAVATT** | Favorable conditions — attached flux file from Traj-Hap |
| **FAVEX** | Favorable conditions — exited flux file from Traj-Hap |
| **UNFATT** | Unfavorable conditions — attached flux file from Traj-Hap |
| **UNFEX** | Unfavorable conditions — exited flux file from Traj-Hap |

Each worksheet contains the summary flux data copied from the corresponding
ASCII flux output file (`HAPHETFLUXATT.OUT`, `HAPHETFLUXEX.OUT`). Example
UPFLUX files are provided in the `upscale/matlab/` directory.

### RFSZ colloids
Colloids retained at the rear flow stagnation zone (RFSZ) are not included
as attached for the purpose of calculating collector efficiency, since all
flow lines converge at the RFSZ and the guaranteed ZOI-heterodomain overlap
there does not represent true surface attachment. UpscaleContinuum handles
this discrimination automatically.

### ATTACHK=4 colloids (functionally arrested)
Colloids flagged as ATTACHK=4 in the `HAPHETFLUXREM.OUT` file are functionally
arrested in contact. The user may optionally append these to the UNFATT
worksheet before loading, treating them as attached depending on the stringency
of DFACT parameters used.

### Maximum file size
The maximum summary flux file size for importing into UpscaleContinuum is
50,000 colloids per worksheet.

---

## User-Specified Parameters

Two parameters require user judgment and are not determined from pore-scale
simulations:

**α_trans-gg** — fraction of RFSZ colloids that transfer directly to the
near-surface of a downstream grain rather than expelling back to bulk fluid.
Depends on grain-to-grain network structure. Currently empirical — can
potentially be characterized from direct observation experiments or multi-grain
mechanistic simulations.

**α_trans-bg** — fraction of re-entrained bulk-fluid colloids that enter the
near-surface of a downstream grain. An additional flexibility parameter;
its physical basis is less certain than α_trans-gg.

**Characteristic velocity for k_ns** — three options:
- **v** — average pore water velocity
- **v₂** — near-surface fluid velocity (determined from trajectory output)
- **(v · v₂)^(1/2)** — geometric mean

The choice of characteristic velocity affects the magnitude of k_ns and the
resulting BTC tailing and RCP shape. See Johnson et al. (2018) for discussion.

---

## Implicit vs. Explicit Near-Surface Simulations

**Implicit** — near-surface fluid domain is not explicitly represented.
Simulations will not explicitly show near-surface colloids in BTCs or RCPs.
Results: BTCs without extended tailing; RCPs ranging from hyper-exponential
to log-linear.

**Explicit** — near-surface fluid domain is explicitly tracked. Near-surface
colloids appear in BTCs (extended tailing) and RCPs (non-monotonic profiles
possible). Results: BTCs with extended tailing; full range of RCP shapes
including non-monotonic profiles.

For systems where extended tailing and non-monotonic RCPs are observed
experimentally, the explicit approach is required.

---

## GUI Usage Notes

The GUI is designed to allow parameter changes between simulations without
closing. However, to guarantee that intended values are used, close and
reopen the GUI between simulations and work sequentially from upper to lower
sections of the GUI.

---

## Output Files

Output files are written to the program directory and contain:
- Predicted BTC (C/C₀ vs. time)
- Predicted RCP (retained colloids vs. distance from source)
- Rate coefficients (k_f, k_f2, k_ns, k_f2*) and all efficiency parameters
  (η, α₁, α₂, α_RFSZ, α_reent, v₂)
- Colloid populations in each domain (attached, near-surface, aqueous) as a
  function of distance

---

## Recommended Workflow

```
1. Run Traj-Hap under favorable conditions (SCOV=0, opposite zeta potentials,
   ATTMODE=0 for perfect sink, NPART ≥ 100)

2. Run Traj-Hap under unfavorable conditions (SCOV > 0 adjusted to match
   observed C/C₀, same colloid/fluid parameters, ATTMODE=1, NPART ≥ 100)

3. Prepare UPFLUX.xls:
   - Copy HAPHETFLUXATT.OUT → FAVATT worksheet
   - Copy HAPHETFLUXEX.OUT  → FAVEX worksheet
   - Copy HAPHETFLUXATT.OUT → UNFATT worksheet  (unfavorable run)
   - Copy HAPHETFLUXEX.OUT  → UNFEX worksheet   (unfavorable run)
   Optionally append ATTACHK=4 colloids from HAPHETFLUXREM.OUT to UNFATT.

4. Load UPFLUX.xls into UpscaleContinuum GUI
   - Review v₂ and efficiency values (α₁, α₂, α_RFSZ, α_reent)
   - Review residence time overlap histogram

5. Set continuum parameters:
   - Column length, pore water velocity, porosity, grain size
   - α_trans-gg and α_trans-bg
   - Characteristic velocity for k_ns

6. Run implicit then explicit simulations
   Compare predicted BTCs and RCPs with experimental data
   Adjust SCOV in Traj-Hap if needed and repeat
```

---

## References

**Upscaling Near-Surface Colloid Transport:**
- Johnson, W.P. and Hilpert, M. (2013). Upscaling colloid transport and
  retention under unfavorable conditions. *Water Resources Research*, 49,
  1–14. https://doi.org/10.1002/wrcr.20433

- Johnson, W.P., Rasmuson, A., Hilpert, M., and Pazmino, E. (2018). Why
  variant colloid transport behaviors emerge among identical individuals in
  porous media when colloid-surface repulsion exists. *Environmental Science
  & Technology*, 52(13), 7230–7239.
  https://doi.org/10.1021/acs.est.8b00811

- Hilpert, M., Rasmuson, A., and Johnson, W.P. (2017). A binomial modeling
  approach for upscaling colloid transport under unfavorable conditions:
  organic prediction of extended tailing. *Water Resources Research*, 53(7),
  5626–5644. https://doi.org/10.1002/2016WR020123

- Hilpert, M. and Johnson, W.P. (2018). A binomial modeling approach for
  upscaling colloid transport under unfavorable attachment conditions:
  emergent prediction of non-monotonic retention profiles. *Water Resources
  Research*, 54(1). https://doi.org/10.1002/2017WR021454

- Johnson, W.P. (2020). Upscaling near-surface colloid transport to predict
  non-exponential retention profiles and breakthrough tailing. *Water
  Resources Research*. https://doi.org/10.1029/2020WR027217

**Interception History Paradigm:**
- Johnson, W.P., Ullauri, L.A., Al-Zghoul, B.M., and Bolster, D. (2025).
  Experimental confirmation of the Interception History paradigm for colloid
  (micro and nanoparticle) transport in porous media. *Environmental Science
  & Technology*, 59(18), 9275–9284.
  https://doi.org/10.1021/acs.est.5c03239

- Volponi, S.N., Al-Zghoul, B., Porta, G., Bolster, D., and Johnson, W.P.
  (2025). Interception history drives colloid transport variance in porous
  media. *Environmental Science & Technology*, 59(6), 3165–3171.
  https://doi.org/10.1021/acs.est.4c06509

- Al-Zghoul, B.M., Johnson, W.P., and Bolster, D. (2025). A paradigm shift
  in colloid filtration: upscaling from grain to Darcy scale. *ARC
  Geophysical Research*, 1, 9. https://doi.org/10.5149/ARC-GR.1582

Full reference list: [`docs/references.md`](../../docs/references.md)
