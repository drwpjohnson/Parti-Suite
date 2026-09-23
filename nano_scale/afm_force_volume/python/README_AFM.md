# AFM Force Simulation

Python implementation of an AFM/Happel force-volume simulator for interactions between a colloidal probe and a collector surface.

The code calculates force profiles that include van der Waals, electrical double layer (EDL), Lewis acid-base, steric, Born, gravity, lift, drag, and diffusion contributions. It also supports collector/probe heterogeneity, surface roughness, force-barrier analysis, primary-minimum analysis, Excel output, and a graphical user interface.

> **Status:** the Python implementation has been compared against the MATLAB reference implementation for homogeneous and heterogeneous cases and for `RMODE = 0, 1, 2, 3`. The currently implemented force calculations agree with the MATLAB reference cases to floating-point precision after the porting corrections described during development.

## Project Structure

```text
.
├── AFM_functions.py
├── AFM_simulator.py
├── AFM_plotting.py
├── AFM_GUI.py
└── README_AFM.md
```

### `AFM_functions.py`

Contains the physical, geometric, heterogeneity, roughness, Excel I/O, and auxiliary functions used by the simulator.

Important functions include:

- `AFMFORCEBORN`: Born repulsive force.
- `AFMFORCESTE`: steric force.
- `AFMFORCEAB`: Lewis acid-base force.
- `AFMFORCEVDW`: van der Waals force.
- `AFMFORCEEDL`: electrical double-layer force.
- `AFMGRAVITY`: gravitational force.
- `AFMFORCELIFT`: lift force.
- `AFMFORCEDRAG`: normal and tangential drag forces.
- `AFMFORCEDIFF`: diffusion/Brownian force.
- `AFMsphere_capEQ`: colloid asperity geometry.
- `AFM_asp_tracking` and `AFM_asp_tracking_RMODE3`: collector-asperity tracking.
- `AFMHETTRACKP`: probe heterodomain generation and tracking.
- `AFMHETTRACK`: collector heterodomain generation and tracking.
- `AFMHETP_TRANSFORM` and `AFMHETC_TRANSFORM`: coordinate transformations.
- `AFMAREAFRACT`: calculation of overlap fractions used in heterogeneous EDL forces.
- `overlap2`, `overlap3`, `overlap4`, `intersection`, and `inside`: overlap geometry.
- `build_matlab_output_sheets`: builds the Excel-compatible output structure.
- `import_afm_inputs`: imports simulation parameters from an AFM Excel workbook.
- `add_analysis_output_sheets`: adds histogram and barrier/minimum results.
- `save_output`: writes and validates the final `.xlsx` workbook.

### `AFM_simulator.py`

Contains the main simulation and standalone workflow.

Important functions:

- `get_default_inputs()`: default standalone input dictionary.
- `AFM_happel(**kwargs)`: main AFM simulation.
- `get_default_analysis_limits()`: calculates the default primary-minimum and barrier separation limits.
- `resolve_analysis_limits()`: validates user-supplied analysis limits.
- `console_progress()`: terminal progress display.
- `run_standalone()`: complete non-GUI simulation, analysis, plotting, and Excel workflow.

### `AFM_plotting.py`

Contains all active plotting and force-profile analysis routines.

Current figures include:

- Interactive 3D force profiles using Plotly.
- Probe locations, zones of influence (ZOI), heterodomains, and collector roughness using Matplotlib.
- Barrier histogram.
- Primary-minimum histogram.
- Barrier spatial heatmap.
- Primary-minimum spatial heatmap.


### `AFM_GUI.py`

CustomTkinter interface for configuring and running the simulation.

The GUI supports:

- Simulation input editing.
- Excel parameter import.
- Heterodomain-mode reference graphics.
- Simulation in a separate process.
- Simulation progress display.
- Force-profile and ZOI plots.
- Adjustable separation-distance limits for barrier/minimum analysis.
- Heatmap and histogram generation.
- Excel export of simulation and analysis results.

## Requirements

The code uses Python type syntax that requires Python 3.10 or newer.

Main dependencies:

```text
numpy
pandas
matplotlib
plotly
openpyxl
customtkinter
```

Install them with:

```bash
python -m pip install numpy pandas matplotlib plotly openpyxl customtkinter
```

`tkinter` is included with most standard Python installations. On some Linux distributions it may need to be installed separately through the system package manager.

## Running the GUI

Run:

```bash
python AFM_GUI.py
```

Typical workflow:

1. Enter or import the simulation parameters.
2. Click **Simulate Force Profiles**.
3. Review the force-profile and ZOI figures.
4. Adjust the separation-distance limits if required.
5. Click **Generate heatmaps and histograms**.
6. Click **Save data to file** to export the simulation and analysis workbook.

The AFM simulation runs in a separate process so that the GUI can update the progress window while the numerical calculation is running.

## Running in Standalone Mode

Run:

```bash
python AFM_simulator.py
```

The bottom of `AFM_simulator.py` contains the standalone configuration.

The main switches are:

```python
IMPORT_FROM_FILE = False
SAVE_EXCEL = False
SHOW_FIGURES = True
SHOW_ANALYSIS_FIGURES = False
```

Their meaning is:

| Variable | Behavior |
|---|---|
| `IMPORT_FROM_FILE` | When `True`, read parameters from an Excel file. When `False`, use `get_default_inputs()`. |
| `SAVE_EXCEL` | Save the simulation and analysis workbook. |
| `SHOW_FIGURES` | Show force profiles and the ZOI/probe-location figure. |
| `SHOW_ANALYSIS_FIGURES` | Show barrier/primary-minimum histograms and heatmaps. |

Set the output location before running:

```python
BASE_OUTPUT_PATH = r"C:\path\to\output"
FOLDER_NAME = "AFM_run"
```

> **Warning:** `create_folder()` removes an existing folder with the same `FOLDER_NAME` before recreating it. Do not point it to a folder that contains files you want to preserve.

When `IMPORT_FROM_FILE = True` and `INPUT_FILE = None`, the standalone workflow asks for the Excel path in the terminal.

The optional analysis limits are:

```python
PRIMARY_MAX_H = None
BARRIER_MIN_H = None
BARRIER_MAX_H = None
```

`None` uses the simulation-derived defaults:

```text
Primary-minimum maximum separation = Hlow - HMIN + HFRIC
Barrier minimum separation         = Hlow - HMIN + HFRIC
Barrier maximum separation         = Hhigh
```

## Surface Roughness Modes

| `RMODE` | Geometry |
|---:|---|
| `0` | Smooth probe and smooth collector |
| `1` | Asperities on the probe |
| `2` | Asperities on the collector |
| `3` | Asperities on both surfaces |

The principal asperity-size inputs are:

- `ASPcolloid`: colloidal-probe asperity radius.
- `ASPdomain`: collector/domain asperity radius.
- `B`: slip length.

All four roughness modes are implemented in the current Python version.

## Heterogeneity Modes

### Collector/domain heterogeneity

`HETMODE` controls the local hierarchy of collector heterodomains:

| `HETMODE` | Local pattern |
|---:|---|
| `1` | 1 large heterodomain |
| `5` | 1 large + 4 medium |
| `9` | 1 large + 8 medium |
| `73` | 1 large + 8 medium + 64 small |

The associated radii are:

```text
RHET0 = large collector heterodomain radius
RHET1 = medium collector heterodomain radius
RHET2 = small collector heterodomain radius
```

### Probe heterogeneity

`HETMODEP` supports:

| `HETMODEP` | Local pattern |
|---:|---|
| `1` | Large probe heterodomain only |
| `5` | 1 large + 4 smaller probe heterodomains |

The associated radii are:

```text
RHETP0 = large probe heterodomain radius
RHETP1 = small probe heterodomain radius
```

`SCOV` and `SCOVP` specify the fractional surface coverage of collector and probe heterodomains, respectively.


## Force-Profile Analysis

The analysis uses the total force profile `FCOLL`.

### Barrier

For every probe location, the code searches the maximum force at separations larger than `barrier_min_h`.

A barrier is accepted only when:

```text
force > 0
and
barrier separation < barrier_max_h
```

If no valid barrier is detected, the corresponding histogram and heatmap are disabled.

### Primary minimum

For every probe location, the code finds the minimum of the force profile and accepts it when:

```text
primary-minimum separation < primary_max_h
```

The implementation intentionally follows the MATLAB analysis behavior and does not require the primary-minimum force itself to be negative.

If no valid primary minimum is detected, its histogram and heatmap are disabled.

## Figures

### Force Profiles

`plot_force_profiles()` creates an interactive Plotly 3D figure:

- X axis: separation distance `H`.
- Y axis: probe index.
- Z axis: total colloidal interaction force `FCOLL`.

The separation axis is logarithmic.

### ZOI / Probe Locations

`plot_probe_locations()` displays:

- probe locations using `LAT1` and `LAT2`;
- final `AFRACT` values;
- ZOI circles in gold;
- collector heterodomains in green;
- collector asperities in blue for `RMODE = 2` and `RMODE = 3`.

Negative `AFRACT` values are clipped to zero for this visualization, matching the MATLAB plotting behavior.

### Histograms and Heatmaps

The analysis can generate:

- barrier-force histogram;
- primary-minimum-force histogram;
- barrier spatial heatmap;
- primary-minimum spatial heatmap.

The heatmaps preserve the actual detected values for hover information even when auxiliary plotting values are used to render missing regions.

## Excel Output

The Python workflow builds the output workbook in memory and writes it with `openpyxl`.

The workbook can contain:

| Sheet | Contents |
|---|---|
| `Parameters` | Simulation parameters and probe locations |
| `FCOLL(N)` | Total interaction-force profiles |
| `FVDW(N)` | van der Waals force profiles |
| `FEDL(N)` | Electrical double-layer force profiles |
| `FAB(N)` | Lewis acid-base force profiles |
| `FSTE(N)` | Steric force profiles |
| `FBORN(N)` | Born force profiles |
| `hetXloc` | Collector heterodomain X locations |
| `hetYloc` | Collector heterodomain Y locations |
| `hetRadii` | Collector heterodomain radii |
| `Hist` | Barrier and primary-minimum histogram data |
| `raw_Bar_Min_data` | Per-probe barrier/minimum force, separation, and location data |

`Hist` and `raw_Bar_Min_data` are added after force-profile analysis.

If a barrier or primary minimum is absent, the corresponding analysis values can remain blank/`NaN` rather than fabricating a value.

## Python/MATLAB Validation

The Python port has been checked against the MATLAB reference implementation for:

- homogeneous surfaces;
- heterogeneous surfaces;
- EDL heterogeneity transformations;
- `RMODE = 0`;
- `RMODE = 1`;
- `RMODE = 2`;
- `RMODE = 3`.

The remaining numerical differences in the validated force cases are at floating-point scale.


## Known Issues in the MATLAB Reference Implementation

The following issues were observed in the MATLAB version and should be corrected on the MATLAB side. They do **not** redefine the intended physical meaning of the Python variables.

1. **`Asperity_height(m)` Excel export**  
   In a tested roughness case, Python reports `2e-8 m`, while the corresponding MATLAB Excel cell is empty.

2. **van der Waals mode selection**  
   The MATLAB implementation does not allow the van der Waals mode to be changed correctly through the current interface/workflow. Therefore these functionalities are not included in the python code.

3. **`RHET0` / `RHET1` Excel export**  
   MATLAB exports the large and medium collector heterodomain radii in exchanged Excel positions. The intended internal meaning remains:

   ```text
   RHET0 = large heterodomain radius
   RHET1 = medium heterodomain radius
   ```

4. **HETMODE figure overwritten by heatmap generation**  
   If the MATLAB HETMODE reference figure is left open and the heatmaps are then generated, the HETMODE figure can be corrupted and its last panel can be replaced by the barrier heatmap.

## Current Limitations

Two geometry figures from the MATLAB workflow are not currently implemented in the Python plotting module:

```text
Near_Surface_Geometry
Contact_Geometry
```

Porting them requires the associated MATLAB geometry/painting routines and is separate from the already validated force calculations.

The current project should therefore be considered complete for the implemented force-volume, roughness, heterogeneity, barrier/minimum analysis, Excel, GUI, and standalone workflows, while those two geometry visualizations remain future work.

## References

1. Gregory, J. (1981). Approximate expressions for retarded van der Waals interaction. *Journal of Colloid and Interface Science, 83*(1), 138–145. https://doi.org/10.1016/0021-9797(81)90018-7

2. Lin, S., & Wiesner, M. R. (2012). Theoretical investigation on the steric interaction in colloidal deposition. *Langmuir, 28*(43), 15233–15245. https://doi.org/10.1021/la302201g

3. Nir, S., & Andersen, M. (1977). Van der Waals interactions between cell surfaces. *Journal of Membrane Biology, 31*(1–2), 1–18. https://doi.org/10.1007/BF01869396

4. Rajagopalan, R., & Tien, C. (1976). Trajectory analysis of deep-bed filtration with the sphere-in-cell porous media model. *AIChE Journal, 22*(3), 523–533. https://doi.org/10.1002/aic.690220316

5. Ruckenstein, E., & Prieve, D. C. (1976). Adsorption and desorption of particles and their chromatographic separation. *AIChE Journal, 22*(2), 276–283. https://doi.org/10.1002/aic.690220209

6. Wood, J. A., & Rehmann, L. (2014). Geometric effects on non-DLVO forces: Relevance for nanosystems. *Langmuir, 30*(16), 4623–4632. https://doi.org/10.1021/la500664c

7. Yahiaoui, S., & Feuillebois, F. (2010). Lift on a sphere moving near a wall in a parabolic flow. *Journal of Fluid Mechanics, 662*, 447–474. https://doi.org/10.1017/S0022112010003307

## Variable Glossary

The following glossary covers the variables that are most useful when reading the simulator. Units are SI unless stated otherwise.

| Variable | Meaning |
|---|---|
| `NPART` | Number of probe locations per lateral axis. The force-volume grid contains `NPART × NPART` probe locations. |
| `NPARTLOOP` | Total number of probe locations, calculated as `NPART**2`. |
| `RLIM` | Lateral size/limit used to generate the force-volume probe grid. |
| `LAT1`, `LAT2` | Lateral coordinates of a probe location in the force-volume grid. |
| `AP` | Colloidal-probe radius. |
| `AG` | Collector/grain radius used in the Happel geometry. In AFM mode the simulator internally sets the collector radius to a very large value relative to `AP` to approximate a flat collector. |
| `H` | Instantaneous probe-collector separation distance. |
| `HS` | Auxiliary/effective separation used by some roughness force expressions. |
| `HMIN` | Minimum separation used by the simulation after determining the maximum-deformation/contact region. |
| `HFRIC` | Separation at which contact/zero-slip behavior is considered to begin. |
| `Hlow` | Lower separation used to construct the force-profile separation vector. |
| `Hhigh` | Upper separation used to construct the force-profile separation vector and the default upper barrier-analysis limit. |
| `RZOI` | Radius of the probe's zone of influence on the collector surface. |
| `RZOIBULK` | Bulk/reference ZOI radius used in heterogeneity and asperity calculations. |
| `SCOV` | Fractional surface coverage of heterodomains on the collector/domain. |
| `SCOVP` | Fractional surface coverage of heterodomains on the colloidal probe. |
| `SCOV0` | Derived/equivalent collector coverage assigned to the large-domain population when `SCOV` is distributed among large, medium, and small heterodomain sizes. |
| `SCOVP0` | Derived/equivalent probe coverage used to determine the large probe-heterodomain population when `HETMODEP` contains more than one size. |
| `HETMODE` | Collector heterodomain hierarchy: `1`, `5`, `9`, or `73`. |
| `HETMODEP` | Probe heterodomain hierarchy: `1` or `5`. |
| `RHET0` | Large collector heterodomain radius. |
| `RHET1` | Medium collector heterodomain radius. |
| `RHET2` | Small collector heterodomain radius. |
| `RHETP0` | Large probe heterodomain radius. |
| `RHETP1` | Small probe heterodomain radius. |
| `ZETACST` | Background collector zeta potential. |
| `ZETAPST` | Background probe zeta potential. |
| `ZETAHET` | Collector heterodomain zeta potential. |
| `ZETAHETP` | Probe heterodomain zeta potential. |
| `AFRACT` | Total heterogeneous/attractive fractional area detected inside the ZOI. It is assembled from overlap fractions and determines whether the EDL force is evaluated as a weighted heterogeneous interaction. When heterogeneity is not evaluated, the simulator can use a negative sentinel value; the ZOI plot clips negative values to zero. |
| `AFRACT_PZ` | Fraction of the ZOI associated with probe heterogeneity without collector-heterodomain overlap. |
| `AFRACT_ZH` | Fraction of the ZOI associated with collector heterodomain overlap. |
| `AFRACT_PZH` | Fraction where projected probe heterogeneity and collector heterogeneity overlap simultaneously. |
| `AFRACT_Z` | Remaining non-overlapped/background fraction of the ZOI. |
| `AF_PZ` | Local overlap fraction returned by `AFMAREAFRACT` for the projected probe heterodomain contribution. |
| `AF_ZH` | Local overlap fraction returned by `AFMAREAFRACT` for the collector heterodomain contribution. |
| `AF_PZH` | Local overlap fraction where probe projection and collector heterodomain overlap. |
| `AF_Z` | Remaining local background fraction returned by `AFMAREAFRACT`. |
| `HETTYPE` | Integer classification of the heterodomain combination detected in the ZOI. It is used as a classification/output variable rather than as the direct source of the heterogeneous EDL weighting. |
| `RMODE` | Roughness mode: `0` smooth, `1` probe roughness, `2` collector roughness, `3` both. |
| `ASPcolloid` | Radius of probe asperities. The GUI field is labeled `Asperity_height(m)` for compatibility with the existing input/output naming. |
| `ASPdomain` | Radius of collector/domain asperities. |
| `B` | Slip length used in the hydrodynamic/contact treatment. |
| `A132` | Combined Hamaker constant for the uncoated van der Waals model. |
| `LAMBDAVDW` | van der Waals retardation/decay length. |
| `VDWMODE` | van der Waals configuration mode. |
| `GAMMA0AB` | Lewis acid-base interaction energy per unit area. |
| `LAMBDAAB` | Lewis acid-base decay length. |
| `GAMMA0STE` | Steric interaction energy per unit area. |
| `LAMBDASTE` | Steric decay length. |
| `KINT` | Combined elastic modulus used in deformation/contact calculations. |
| `W132` | Work of adhesion. |
| `BETA` | Contact-radius factor used in the deformation/contact model. |
| `KAPPA` | Inverse Debye-length parameter used by the EDL model. |
| `FVDW` | van der Waals force. |
| `FEDL` | Electrical double-layer force. |
| `FAB` | Lewis acid-base force. |
| `FSTE` | Steric force. |
| `FBORN` | Born repulsive force. |
| `FCOLL` | Total colloidal surface-interaction force, calculated from the implemented interaction-force components. |
| `FCOLLOT`, `FVDWOT`, `FEDLOT`, `FABOT`, `FSTEOT`, `FBORNOT` | Matrices storing the corresponding force profile for every probe location. |
| `HOT` | Matrix storing separation-distance values during the simulation. |
| `HVECTOR` | Reference separation vector used for the force-profile outputs. |

