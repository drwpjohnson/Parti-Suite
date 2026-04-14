# Continuum Scale — Colloid Transport Prediction

This module provides tools for predicting continuum-scale colloid transport
behaviors — breakthrough-elution concentration histories (BTCs) and profiles
of retained colloids as a function of distance from source (RCPs) — from
pore-scale trajectory simulations. Two complementary approaches are provided:
mechanistic upscaling via the Interception History framework (Upscale), and
forward prediction using the Interception History spreadsheet tool
(InterceptionHistory).

---

## Background

### From Pore Scale to Continuum Scale

Colloid transport in granular porous media at the laboratory to field scale was
originally expected to show compounded, log-linear loss for each grain passed —
the expectation of classical colloid filtration theory under favorable
conditions. This expectation is met under favorable conditions (opposite-charged
surfaces), where a single irreversible retention rate coefficient (k_f) is
sufficient to describe observed BTCs and exponential RCPs.

Under unfavorable conditions (like-charged surfaces), however, observed BTCs
and RCPs consistently deviate from this simple expectation:

- **Extended tailing** of low colloid concentrations following initial elution
  in BTCs, well after the plateau has ended
- **Non-exponential (hyper-exponential or non-monotonic) RCPs** where retention
  decreases more steeply near the source than classical filtration theory
  predicts, and in some cases increases with distance before decreasing again

These behaviors arise from processes operating in the near-surface fluid domain
that are not captured by classical filtration theory: fast- and slow-attaching
sub-populations, near-surface colloids retained without attachment in low-shear
zones, and colloids that re-entrain to bulk fluid rather than attaching.

### Upscaling Near-Surface Colloid Transport and the Interception History Paradigm

The framework for upscaling near-surface colloid transport (Johnson and
Hilpert, 2013; Johnson et al., 2018; Hilpert et al., 2017; Hilpert and
Johnson, 2018; Johnson, 2020) mechanistically links pore-scale trajectory
outcomes to continuum-scale rate coefficients by expanding the upscaling
control boundary from the grain surface to include the full near-surface fluid
domain (within ~200 nm of the grain surface). This body of work has been
named the Interception History paradigm, experimentally confirmed in Johnson
et al. (2025a), and further developed in Al-Zghoul et al. (2024, 2025a,
2025b, 2025c) and Volponi et al. (2025a, 2025b).

Under unfavorable conditions, colloids delivered to the near-surface fluid
domain may experience four distinct outcomes, each characterized by an
efficiency (as a fraction of all near-surface colloids):

| Efficiency | Symbol | Outcome |
|------------|--------|---------|
| Fast attachment | α₁ | Attach with residence times comparable to favorable conditions |
| Slow attachment | α₂ | Attach after longer near-surface residence times |
| Re-entrainment | α_reent | Return to bulk fluid without attaching |
| RFSZ retention | α_RFSZ | Retained in rear flow stagnation zone (low-shear) |

These four efficiencies sum to unity and are determined directly from the
residence time distributions in pore-scale trajectory simulations. The product
of the collector efficiency (η) and each near-surface efficiency gives the
fraction of bulk-fluid colloids culminating in each outcome.

### Rate Coefficients

The Interception History framework upscales these pore-scale efficiencies to
continuum-scale rate coefficients:

**Favorable conditions:**
```
k_f = -(N_c/L · v) · ln(1 - η)
```
where N_c/L is the number of collectors per unit length and v is the average
pore water velocity.

**Unfavorable conditions — implicit near-surface:**
- k_f applied to the α₁ (fast-attaching) sub-fraction
- k_f2 applied to the remaining (1-α₁) sub-fraction, scaled to the near-surface
  fluid velocity v₂ and incorporating α₂, α_RFSZ, and grain-to-grain transfer
  efficiencies

**Unfavorable conditions — explicit near-surface:**
- k_ns replaces k_f2 — the rate coefficient for net transfer to the near-surface
  fluid domain
- Near-surface colloids are explicitly tracked and translated at v₂, with
  attachment governed by k_f2*

The explicit near-surface approach produces extended BTC tailing and
non-monotonic RCPs that are absent from implicit simulations, providing
mechanistic prediction of the full range of observed continuum-scale behaviors.

### Fast- and Slow-Attaching Sub-populations

A key insight of the Interception History framework is that a population of
identical colloids effectively separates into fast- and slow-attaching
sub-populations based on their initial positions in the flow field — some
initial positions happen to lie on streamlines that deliver colloids rapidly to
heterodomains (fast attachment), while others require longer near-surface
residence times or do not attach at all. This fast-attaching sub-population
is not replenished during transport from grain to grain, so it is rapidly
depleted with increasing transport distance. The remaining slow-attaching
population produces the hyper-exponential decline in RCPs observed under
unfavorable conditions.

---

## Modules

### `upscale/` — Upscale (Matlab)

Reads trajectory simulation output from the Happel sphere-in-cell code
(`pore_scale/trajectory/happel/`) and performs the full Interception History
upscaling workflow:

1. **Reads UPFLUX files** — user-prepared Excel files containing favorable and
   unfavorable attached and exited flux data from Traj-Hap simulations
2. **Determines near-surface velocity** (v₂) from near-surface colloid velocity
   data in the trajectory output
3. **Constructs residence time histograms** — overlapping favorable and
   unfavorable attachment time distributions that define α₁ and α₂
4. **Calculates efficiencies** — η, α₁, α₂, α_RFSZ, α_reent from the pore-scale
   trajectory data
5. **Upscales to rate coefficients** — k_f, k_f2/k_ns, k_f2* using
   user-specified grain-to-grain transfer efficiencies (α_trans-gg, α_trans-bg)
   and characteristic velocity choice (v, v₂, or geometric mean)
6. **Runs continuum-scale Lagrangian simulations** — predicts BTCs and RCPs
   under both implicit and explicit near-surface representations

**Platforms:** Matlab  
**Input:** UPFLUX.xls files prepared from Traj-Hap output (see below)  
**Output:** Predicted BTCs, RCPs, rate coefficients, and efficiency parameters

#### Preparing UPFLUX Files

UpscaleContinuum reads a user-prepared Excel file (e.g., `UPFLUX.xls`)
containing four worksheets in the following order:

| Worksheet | Contents |
|-----------|----------|
| FAVATT | Favorable conditions — attached flux file |
| FAVEX | Favorable conditions — exited flux file |
| UNFATT | Unfavorable conditions — attached flux file |
| UNFEX | Unfavorable conditions — exited flux file |

Each worksheet contains the summary flux data from the corresponding Traj-Hap
run, copied from the ASCII flux output files. Example UPFLUX files are provided
in the `upscale/` directory.

**Note:** Colloids retained at the rear flow stagnation zone (RFSZ) are
not included as attached for the purpose of calculating collector efficiency,
as all flow lines converge at the RFSZ and the guaranteed ZOI-heterodomain
overlap there does not represent true attachment. UpscaleContinuum handles this
discrimination automatically.

#### User-Specified Parameters

Two parameters require user judgment and are not determined from pore-scale
simulations:

**α_trans-gg** — fraction of RFSZ colloids that transfer directly to the
near-surface of a downstream grain rather than expelling back to bulk fluid.
Depends on grain-to-grain network structure; currently empirical.

**α_trans-bg** — fraction of re-entrained bulk-fluid colloids that enter the
near-surface of a downstream grain. An additional flexibility parameter; its
relevance is less certain than α_trans-gg.

**Characteristic velocity for k_ns** — ranges between v₂ (near-surface
velocity) and v (average pore water velocity). The geometric mean (v·v₂)^(1/2)
is provided as an intermediate option.

📺 Videos: [Upscale Background](https://youtu.be/HqJTNf7MO2k) ·
[Upscale How-To](https://youtu.be/IhZN15s9AT4)

See [`upscale/README.md`](upscale/README.md) for full documentation.

---

### `interception_history/` — Interception History (Excel)

Implements forward prediction of continuum-scale colloid transport data from
pore-scale parameters using the Interception History framework. Provides rapid
prediction of BTCs and RCPs directly from user-specified efficiency values and
rate coefficients, without requiring full trajectory simulations.

**Platforms:** Excel  
**Use case:** Forward prediction, sensitivity analysis, comparison with
experimental data when pore-scale simulations have already been run or when
efficiency values are estimated from literature

See [`interception_history/README.md`](interception_history/README.md) for
full documentation.

---

## Recommended Workflow

```
1. Run Traj-Hap (pore_scale/trajectory/happel/) under:
   a. Favorable conditions (ZETAPST and ZETACST opposite sign, SCOV=0)
   b. Unfavorable conditions (like-charged surfaces, SCOV > 0 adjusted
      to match observed attachment efficiency)

2. Prepare UPFLUX.xls from the Traj-Hap flux output files:
   Copy FAVATT, FAVEX, UNFATT, UNFEX worksheets in order.

3. Load UPFLUX.xls into UpscaleContinuum (upscale/matlab/).
   - Review residence time overlap histogram (α₁ vs α₂ separation)
   - Note v₂ and efficiency values determined by the code

4. Set continuum parameters:
   - Column length, pore water velocity, porosity, grain size
   - α_trans-gg (grain-to-grain transfer efficiency)
   - Characteristic velocity choice for k_ns

5. Run implicit and explicit simulations.
   Compare predicted BTCs and RCPs with experimental observations.
   Adjust SCOV in Traj-Hap if needed to match observed C/C₀.
```

The key tuning parameter is **SCOV** (heterodomain surface coverage) in the
Traj-Hap simulation, which the user adjusts to match the experimentally
observed steady-state breakthrough concentration (C/C₀) under unfavorable
conditions. The Interception History framework then mechanistically predicts
the full BTC shape and RCP from this single tuned parameter.

---

## Example Results

The figures below illustrate the range of continuum-scale behaviors predicted
by UpscaleContinuum for 1 µm carboxylate-modified microspheres (CML) in glass
beads and quartz sand at 4 m/day pore water velocity, 6 mM NaCl.

**Glass beads** — implicit simulation produces hyper-exponential RCPs with no
near-surface population; explicit simulation adds near-surface colloids and
extended BTC tailing.

**Quartz sand** — explicit simulation with α_trans-gg > 0 produces non-monotonic
RCPs, reproducing the experimentally observed behavior that cannot be captured
by classical filtration theory.

See `upscale/` for the example UPFLUX files and figures used to generate
these results.

---

## References

**Textbook (primary reference):**
- Johnson, W.P. and Pazmiño, E.F. (2023). *Colloid (Nano- and Micro-Particle)
  Transport and Surface Interaction in Groundwater*. The Groundwater Project.
  https://doi.org/10.21083/978-1-77470-070-9 — Section 6 (freely available)

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
- Johnson, W.P., Ullauri, L.A., Al-Zghoul, B.M., and Bolster, D. (2025a).
  Experimental confirmation of the Interception History paradigm for colloid
  (micro and nanoparticle) transport in porous media. *Environmental Science
  & Technology*, 59(18), 9275–9284.
  https://doi.org/10.1021/acs.est.5c03239

- Volponi, S.N., Al-Zghoul, B., Porta, G., Bolster, D., and Johnson, W.P.
  (2025a). Interception history drives colloid transport variance in porous
  media. *Environmental Science & Technology*, 59(6), 3165–3171.
  https://doi.org/10.1021/acs.est.4c06509

- Volponi, S.N., Al-Zghoul, B., Porta, G., Bolster, D., and Johnson, W.P.
  (2025b). Predicting experimental colloid removal with an inverse
  two-population model. *Advances in Water Resources*, 197, 104905.
  https://doi.org/10.1016/j.advwatres.2025.104905

- Al-Zghoul, B.M., Johnson, W.P., and Bolster, D. (2025a). A paradigm shift
  in colloid filtration: upscaling from grain to Darcy scale. *ARC
  Geophysical Research*, 1, 9. https://doi.org/10.5149/ARC-GR.1582

- Al-Zghoul, B.M., Johnson, W.P., Ullauri, D., and Bolster, D. (2025b).
  Parameters driving anomalous transport in colloids: dimensional analysis.
  *Langmuir*, 41(30), 19924–19938.
  https://doi.org/10.1021/acs.langmuir.5c01956

- Al-Zghoul, B.M., Johnson, W.P., and Bolster, D. (2025c). A training
  trajectory random walk model for predicting colloid transport under
  favorable and unfavorable conditions. *Advances in Water Resources*,
  196, 104878. https://doi.org/10.1016/j.advwatres.2024.104878

- Al-Zghoul, B.M., Volponi, S.N., Johnson, W.P., and Bolster, D. (2024).
  Effects of initial injection condition on colloid retention. *Water
  Resources Research*, 60, e2023WR036877.
  https://doi.org/10.1029/2023WR036877

Full reference list: [`docs/references.md`](../docs/references.md)
