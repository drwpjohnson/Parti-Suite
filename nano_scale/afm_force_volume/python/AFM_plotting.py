"""Plotting utilities for AFM simulations.

The figures are organized according to the GUI workflow:

Default figures
---------------
1. Force profiles.
2. Probe locations / zones of influence.

Heterodomain figures
--------------------
3. Heterodomain figure 1.
4. Heterodomain figure 2.

Force-analysis figures
----------------------
5. Barrier histogram.
6. Primary-minimum histogram.
7. Barrier/maxima spatial map.
8. Primary-minimum spatial map.
"""

from __future__ import annotations
from typing import Any
from matplotlib.figure import Figure
import matplotlib.pyplot as plt
import plotly.graph_objects as go
import numpy as np
from mpl_toolkits.mplot3d import proj3d



def plot_force_profiles(
    results: dict[str, Any],
    *,
    show: bool = True,
) -> go.Figure:
    """Plot AFM force profiles reproducing the current GUI figure.

    Parameters
    ----------
    results
        Dictionary returned by ``AFM_happel()``.

        Required data::

            results["force"]["H_reference"]
            results["force"]["FCOLL"]

    show
        Open the interactive figure in the browser when True.

    Returns
    -------
    plotly.graph_objects.Figure
        Interactive 3D force-profile figure.
    """
    if "force" not in results:
        raise KeyError(
            "results does not contain the 'force' section."
        )

    force_results = results["force"]

    if "H_reference" not in force_results:
        raise KeyError("results['force'] does not contain 'H_reference'.")

    if "FCOLL" not in force_results:
        raise KeyError("results['force'] does not contain 'FCOLL'.")

    distance = np.asarray(
        force_results["H_reference"],
        dtype=float,
    ).reshape(-1)

    force_profiles = np.asarray(
        force_results["FCOLL"],
        dtype=float,
    )

    if force_profiles.ndim != 2:
        raise ValueError(
            "FCOLL must have shape (nsteps, nprobes)."
        )

    if force_profiles.shape[0] != distance.size:
        raise ValueError(
            "H_reference and FCOLL must have the same "
            "number of simulation steps."
        )

    positive_mask = (
        np.isfinite(distance)
        & (distance > 0.0)
    )

    positive_distance = distance[
        positive_mask
    ]

    positive_forces = force_profiles[
        positive_mask,
        :,
    ]

    if positive_distance.size == 0:
        raise ValueError(
            "H_reference contains no positive separation values."
        )

    finite_forces = positive_forces[
        np.isfinite(positive_forces)
    ]

    if finite_forces.size == 0:
        raise ValueError(
            "FCOLL contains no finite force values."
        )

    min_force = float(
        np.min(finite_forces)
    )

    max_force = float(
        np.max(finite_forces)
    )

    nprobes = positive_forces.shape[1]

    figure = go.Figure()

    z_max = 0.03 * max_force
    
    if z_max <= min_force:
        z_max = max_force

    for probe_index in range(nprobes):
        probe_number = probe_index + 1

        force_values = positive_forces[
            :,
            probe_index,
        ]

        valid = np.isfinite(force_values)

        if not np.any(valid):
            continue

        figure.add_trace(
            go.Scatter3d(
                x=positive_distance[valid],
                y=np.full(
                    np.count_nonzero(valid),
                    probe_number,
                    dtype=int,
                ),
                z=force_values[valid],
                mode="lines",
                line={
                    "width": 2,
                    "color": force_values[valid],
                    "colorscale": "Turbo",
                    "showscale": probe_index == 0,
                    "colorbar": {
                        "title": "Force",
                        "exponentformat": "power",
                    },
                    "cmin": min_force,
                    "cmax": z_max,
                },
            )
        )

    figure.update_layout(
        title={
            "text": "AFM Force Profiles",
            "x": 0.5,
            "xanchor": "center",
        },

        scene={
            "xaxis": {
                "title": "H (m)",
                "type": "log",
                "showexponent": "last",
                "exponentformat": "power",
            },
            "yaxis": {
                "title": "Index",
            },
            "zaxis": {
                "title": "Force (N)",
                "range": [
                    min_force,
                    z_max,
                ],
                "showexponent": "last",
                "exponentformat": "power",
            },
        },
        showlegend=False,
    )

    if show:
        figure.show(
            renderer="browser"
        )

    return figure

def _circle_coordinates(
    center_x: float,
    center_y: float,
    radius: float,
    *,
    z: float = 0.0,
    points: int = 50,
) -> tuple[np.ndarray, np.ndarray, np.ndarray]:
    """Return coordinates for a circle parallel to the XY plane."""

    theta = np.linspace(
        0.0,
        2.0 * np.pi,
        points + 1,
    )

    x_values = center_x + radius * np.cos(theta)
    y_values = center_y + radius * np.sin(theta)
    z_values = np.full_like(theta, z, dtype=float)

    return x_values, y_values, z_values

def _roughness_plot_coordinates(
    x_value: float,
    y_value: float,
    z_value: float,
    axis_string: str,
) -> tuple[float, float]:
    """Transform domain-asperity coordinates to the AFM plotting plane."""

    if axis_string == "x":
        return y_value, z_value

    if axis_string == "y":
        return x_value, z_value

    if axis_string == "z":
        return x_value, y_value

    raise ValueError(
        f"Unsupported AXstring: {axis_string!r}. "
        "Expected 'x', 'y', or 'z'."
    )
                
def plot_probe_locations(
    results: dict,
    *,
    figsize: tuple[float, float] = (10.0, 7.0),
    show: bool = True,
) -> Figure:
    """Plot MATLAB-style 3D ZOI, AFRACT, heterodomains, and roughness."""

    metadata = results["metadata"]
    probes = results["probes"]
    heterodomains = results["heterodomains"]
    roughness = results.get("roughness", {})

    probe_x = np.asarray(
        probes["LAT1"],
        dtype=float,
    ).reshape(-1)

    probe_y = np.asarray(
        probes["LAT2"],
        dtype=float,
    ).reshape(-1)

    rzoi = np.asarray(
        probes["RZOI"],
        dtype=float,
    ).reshape(-1)

    afraction = np.asarray(
        probes["AFRACT"],
        dtype=float,
    ).reshape(-1)

    if not (
        probe_x.size
        == probe_y.size
        == rzoi.size
        == afraction.size
    ):
        raise ValueError(
            "LAT1, LAT2, RZOI, and AFRACT must have the same length."
        )

    # MATLAB: afaux(afaux < 0) = 0
    afraction = afraction.copy()
    afraction[afraction < 0.0] = 0.0

    figure = plt.figure(
        figsize=figsize,
    )

    axis = figure.add_subplot(
        111,
        projection="3d",
    )

    # --------------------------------------------------------
    # Probe locations + AFRACT antennae
    # --------------------------------------------------------

    for x_value, y_value, fraction in zip(
        probe_x,
        probe_y,
        afraction,
    ):
        if not (
            np.isfinite(x_value)
            and np.isfinite(y_value)
            and np.isfinite(fraction)
        ):
            continue

        if fraction > 0.0:
            axis.plot(
                [x_value, x_value],
                [y_value, y_value],
                [0.0, fraction],
                color="cyan",
                linewidth=1.0,
            )

            axis.scatter(
                [x_value],
                [y_value],
                [fraction],
                marker="s",
                s=22,
                facecolors="blue",
                edgecolors="cyan",
            )

        else:
            axis.scatter(
                [x_value],
                [y_value],
                [0.0],
                marker="s",
                s=18,
                facecolors="black",
                edgecolors="black",
            )

    # --------------------------------------------------------
    # ZOI circles
    # --------------------------------------------------------

    for x_value, y_value, radius in zip(
        probe_x,
        probe_y,
        rzoi,
    ):
        if not (
            np.isfinite(x_value)
            and np.isfinite(y_value)
            and np.isfinite(radius)
            and radius > 0.0
        ):
            continue

        circle_x, circle_y, circle_z = _circle_coordinates(
            x_value,
            y_value,
            radius,
            z=0.0,
            points=50,
        )

        axis.plot(
            circle_x,
            circle_y,
            circle_z,
            color="gold",
            linewidth=2.0,
        )

    # --------------------------------------------------------
    # Collector heterodomains
    # --------------------------------------------------------

    het_x = np.asarray(
        heterodomains["X"],
        dtype=float,
    )

    het_y = np.asarray(
        heterodomains["Y"],
        dtype=float,
    )

    het_radius = np.asarray(
        heterodomains["radius"],
        dtype=float,
    )

    het_count = np.asarray(
        heterodomains["count"],
        dtype=float,
    ).reshape(-1)

    probe_count = min(
        probe_x.size,
        het_x.shape[1],
        het_y.shape[1],
        het_radius.shape[1],
        het_count.size,
    )

    for probe_index in range(probe_count):
        if not np.isfinite(
            het_count[probe_index]
        ):
            continue

        count = min(
            int(het_count[probe_index]),
            het_x.shape[0],
            het_y.shape[0],
            het_radius.shape[0],
        )

        for domain_index in range(count):
            x_value = het_x[
                domain_index,
                probe_index,
            ]

            y_value = het_y[
                domain_index,
                probe_index,
            ]

            radius = het_radius[
                domain_index,
                probe_index,
            ]

            if not (
                np.isfinite(x_value)
                and np.isfinite(y_value)
                and np.isfinite(radius)
                and radius > 0.0
            ):
                continue

            circle_x, circle_y, circle_z = _circle_coordinates(
                x_value,
                y_value,
                radius,
                z=0.0,
                points=50,
            )

            axis.plot(
                circle_x,
                circle_y,
                circle_z,
                color="green",
                linewidth=1.0,
            )

    # --------------------------------------------------------
    # Domain roughness
    #
    # MATLAB shows these only for RMODE 2 and 3.
    # --------------------------------------------------------

    rmode = int(
        roughness.get(
            "RMODE",
            metadata.get("RMODE", 0),
        )
    )

    axis_string = str(
        metadata.get(
            "AXstring",
            "y",
        )
    ).lower()

    if rmode in (2, 3):
        asperity_radius = float(
            roughness["ASPdomain"]
        )

        rough_x = np.asarray(
            roughness["X"],
            dtype=float,
        )

        rough_y = np.asarray(
            roughness["Y"],
            dtype=float,
        )

        rough_z = np.asarray(
            roughness["Z"],
            dtype=float,
        )

        rough_count = np.asarray(
            roughness["count"],
            dtype=float,
        ).reshape(-1)

        rough_probe_count = min(
            rough_x.shape[1],
            rough_y.shape[1],
            rough_z.shape[1],
            rough_count.size,
        )

        for probe_index in range(
            rough_probe_count
        ):
            if not np.isfinite(
                rough_count[probe_index]
            ):
                continue

            count = min(
                int(rough_count[probe_index]),
                rough_x.shape[0],
                rough_y.shape[0],
                rough_z.shape[0],
            )

            for asperity_index in range(count):
                x_value = rough_x[
                    asperity_index,
                    probe_index,
                ]

                y_value = rough_y[
                    asperity_index,
                    probe_index,
                ]

                z_value = rough_z[
                    asperity_index,
                    probe_index,
                ]

                if not (
                    np.isfinite(x_value)
                    and np.isfinite(y_value)
                    and np.isfinite(z_value)
                ):
                    continue

                plot_x, plot_y = _roughness_plot_coordinates(
                    x_value,
                    y_value,
                    z_value,
                    axis_string,
                )

                circle_x, circle_y, circle_z = _circle_coordinates(
                    plot_x,
                    plot_y,
                    asperity_radius,
                    z=0.0,
                    points=20,
                )

                axis.plot(
                    circle_x,
                    circle_y,
                    circle_z,
                    linestyle="--",
                    color="blue",
                    linewidth=1.0,
                )

    # --------------------------------------------------------
    # MATLAB-style labels/title
    # --------------------------------------------------------

    finite_rzoi = rzoi[
        np.isfinite(rzoi)
        & (rzoi > 0.0)
    ]

    if finite_rzoi.size:
        rzoi_nm = finite_rzoi[0] * 1.0e9
        title_lines = [
            f"ZOI radius ({rzoi_nm:.3g} nm, gold circles)",
            "Rotate figure to see plan view",
        ]
    else:
        title_lines = [
            "ZOI radius",
            "Rotate figure to see plan view",
        ]

    scov = float(
        metadata.get(
            "SCOV",
            0.0,
        )
    )

    if scov > 0.0:
        title_lines.append(
            "Probe-detected Collector Heterodomains "
            "(green circles)"
        )

    if rmode in (2, 3):
        title_lines.append(
            "Probe-detected Domain-Asperities Locations "
            "(blue circles)"
        )

    axis.set_title(
        "\n".join(title_lines)
    )

    axis.set_xlabel(
        "LAT1 (m)"
    )

    axis.set_ylabel(
        "LAT2 (m)"
    )

    axis.set_zlabel(
        "Fraction of ZOI\noccupied by heterodomain"
    )

    axis.set_zlim(
        bottom=0.0
    )

    figure.tight_layout()

    if show:
        plt.show()

    return figure

def analyze_force_profiles(
    results: dict[str, Any],
    *,
    barrier_min_h: float = 5.685e-9,
    barrier_max_h: float = 5.0021e-7,
    primary_max_h: float = 5.685e-9,
    nbins: int = 10,
) -> dict[str, Any]:
    """Calculate barrier and primary-minimum data for AFM analysis plots.

    This reproduces the analysis performed by ``plot_generate`` in the
    original GUI without reading data from Excel.

    Parameters
    ----------
    results
        Results dictionary returned by ``AFM_happel()``.

    barrier_min_h
        Minimum separation considered when searching for the force barrier.

    barrier_max_h
        Maximum accepted separation for a detected barrier.

    primary_max_h
        Maximum accepted separation for the primary minimum.

    nbins
        Number of histogram edge values, matching the original GUI.

    Returns
    -------
    dict
        Barrier, primary-minimum, histogram, and spatial-map data.
    """
    if "force" not in results:
        raise KeyError(
            "results does not contain the 'force' section."
        )

    if "probes" not in results:
        raise KeyError(
            "results does not contain the 'probes' section."
        )

    if "metadata" not in results:
        raise KeyError(
            "results does not contain the 'metadata' section."
        )

    force_results = results["force"]
    probe_results = results["probes"]
    metadata = results["metadata"]

    required_force_keys = (
        "H_reference",
        "FCOLL",
    )

    for key in required_force_keys:
        if key not in force_results:
            raise KeyError(
                f"results['force'] does not contain '{key}'."
            )

    required_probe_keys = (
        "LAT1",
        "LAT2",
    )

    for key in required_probe_keys:
        if key not in probe_results:
            raise KeyError(
                f"results['probes'] does not contain '{key}'."
            )

    required_metadata_keys = (
        "NPART",
        "NPARTLOOP",
        "RLIM",
    )

    for key in required_metadata_keys:
        if key not in metadata:
            raise KeyError(
                f"results['metadata'] does not contain '{key}'."
            )

    hot = np.asarray(
        force_results["H_reference"],
        dtype=float,
    ).reshape(-1)

    profiles = np.asarray(
        force_results["FCOLL"],
        dtype=float,
    )

    probe_x = np.asarray(
        probe_results["LAT1"],
        dtype=float,
    ).reshape(-1)

    probe_y = np.asarray(
        probe_results["LAT2"],
        dtype=float,
    ).reshape(-1)

    npart = int(metadata["NPART"])
    npartloop = int(metadata["NPARTLOOP"])
    rlim = float(metadata["RLIM"])

    if profiles.ndim != 2:
        raise ValueError(
            "FCOLL must have shape (nsteps, nprobes)."
        )

    if profiles.shape[0] != hot.size:
        raise ValueError(
            "H_reference and FCOLL must contain the same "
            "number of simulation steps."
        )

    if profiles.shape[1] != npartloop:
        raise ValueError(
            "The number of FCOLL profiles does not match NPARTLOOP."
        )

    if probe_x.size != npartloop or probe_y.size != npartloop:
        raise ValueError(
            "Probe coordinates must contain one X/Y position "
            "for every force profile."
        )

    if npart * npart != npartloop:
        raise ValueError(
            "NPARTLOOP must equal NPART**2 for the spatial maps."
        )

    if nbins < 2:
        raise ValueError(
            "nbins must be at least 2."
        )

    # --------------------------------------------------------
    # Force barrier
    # --------------------------------------------------------

    barrier_mask = hot > barrier_min_h
    barrier_rows = np.flatnonzero(
        barrier_mask
    )

    if barrier_rows.size == 0:
        raise ValueError(
            "No H values satisfy H > barrier_min_h."
        )

    barrier_profiles = profiles[
        barrier_rows,
        :,
    ]

    barrier_local_indices = np.argmax(
        barrier_profiles,
        axis=0,
    )

    barrier_indices = barrier_rows[
        barrier_local_indices
    ]

    probe_indices = np.arange(
        npartloop
    )

    barrier_raw = profiles[
        barrier_indices,
        probe_indices,
    ]

    barrier_h = hot[
        barrier_indices
    ]

    valid_barrier = (
        np.isfinite(barrier_raw)
        & (barrier_raw > 0.0)
        & np.isfinite(barrier_h)
        & (barrier_h < barrier_max_h)
    )

    barrier_force = np.full(
        npartloop,
        np.nan,
        dtype=float,
    )

    barrier_distance = np.full(
        npartloop,
        np.nan,
        dtype=float,
    )

    barrier_x = np.full(
        npartloop,
        np.nan,
        dtype=float,
    )

    barrier_y = np.full(
        npartloop,
        np.nan,
        dtype=float,
    )

    barrier_force[
        valid_barrier
    ] = barrier_raw[
        valid_barrier
    ]

    barrier_distance[
        valid_barrier
    ] = barrier_h[
        valid_barrier
    ]

    barrier_x[
        valid_barrier
    ] = probe_x[
        valid_barrier
    ]

    barrier_y[
        valid_barrier
    ] = probe_y[
        valid_barrier
    ]

    # --------------------------------------------------------
    # Primary minimum
    # --------------------------------------------------------

    primary_indices = np.argmin(
        profiles,
        axis=0,
    )

    primary_raw = profiles[
        primary_indices,
        probe_indices,
    ]

    primary_h = hot[
        primary_indices
    ]

    # The original GUI calculates csignmin but does not use it.
    # We preserve that behavior here.
    valid_primary = (
        np.isfinite(primary_raw)
        & np.isfinite(primary_h)
        & (primary_h < primary_max_h)
    )

    primary_force = np.full(
        npartloop,
        np.nan,
        dtype=float,
    )

    primary_distance = np.full(
        npartloop,
        np.nan,
        dtype=float,
    )

    primary_x = np.full(
        npartloop,
        np.nan,
        dtype=float,
    )

    primary_y = np.full(
        npartloop,
        np.nan,
        dtype=float,
    )

    primary_force[
        valid_primary
    ] = primary_raw[
        valid_primary
    ]

    primary_distance[
        valid_primary
    ] = primary_h[
        valid_primary
    ]

    primary_x[
        valid_primary
    ] = probe_x[
        valid_primary
    ]

    primary_y[
        valid_primary
    ] = probe_y[
        valid_primary
    ]

    # --------------------------------------------------------
    # Barrier limits
    # --------------------------------------------------------

    valid_barrier_values = barrier_force[
        np.isfinite(barrier_force)
    ]

    has_barrier = (
        valid_barrier_values.size > 0
    )

    if has_barrier:
        low_barrier = float(
            np.min(valid_barrier_values) / 2.0
        )

        high_barrier = float(
            np.max(valid_barrier_values) * 2.0
        )

    else:
        low_barrier = np.nan
        high_barrier = np.nan

    # --------------------------------------------------------
    # Primary-minimum limits
    # --------------------------------------------------------

    valid_primary_values = primary_force[
        np.isfinite(primary_force)
    ]

    has_primary_minimum = (
        valid_primary_values.size > 0
    )

    if has_primary_minimum:
        high_primary = float(
            np.max(valid_primary_values) / 2.0
        )

        low_primary = float(
            np.min(valid_primary_values) * 2.0
        )

    else:
        high_primary = np.nan
        low_primary = np.nan


    # --------------------------------------------------------
    # Spatial grid
    # --------------------------------------------------------

    lat1_limits = np.linspace(
        -rlim / 2.0,
        rlim / 2.0,
        npart,
    )

    lat2_limits = np.linspace(
        -rlim / 2.0,
        rlim / 2.0,
        npart,
    )

    lat1_grid, lat2_grid = np.meshgrid(
        lat1_limits,
        lat2_limits,
    )

    barrier_grid_hist = barrier_force.reshape(
        npart,
        npart,
    ).copy()

    primary_grid_hist = primary_force.reshape(
        npart,
        npart,
    ).copy()

    barrier_grid_plot = barrier_grid_hist.copy()
    primary_grid_plot = primary_grid_hist.copy()

    if np.isfinite(low_barrier):
        barrier_grid_plot[
            np.isnan(barrier_grid_plot)
        ] = low_barrier / 100.0

    if has_primary_minimum:
        primary_grid_plot[
            np.isnan(primary_grid_plot)
        ] = high_primary / 100.0

    # --------------------------------------------------------
    # Histogram bins
    #
    # geobin == 0 in the original GUI.
    # --------------------------------------------------------

    if (
        np.isfinite(low_barrier)
        and np.isfinite(high_barrier)
    ):
        edges_barrier = np.linspace(
            low_barrier,
            high_barrier,
            nbins,
        )

        centers_barrier = 0.5 * (
            edges_barrier[:-1]
            + edges_barrier[1:]
        )

        barrier_counts = np.histogram(
            valid_barrier_values,
            bins=edges_barrier,
        )[0]

    else:
        edges_barrier = np.array(
            [],
            dtype=float,
        )

        centers_barrier = np.array(
            [],
            dtype=float,
        )

        barrier_counts = np.array(
            [],
            dtype=int,
        )

    if has_primary_minimum:
        edges_primary = np.linspace(
            low_primary,
            high_primary,
            nbins,
        )

        centers_primary = 0.5 * (
            edges_primary[:-1]
            + edges_primary[1:]
        )

        primary_counts = np.histogram(
            valid_primary_values,
            bins=edges_primary,
        )[0]

    else:
        edges_primary = np.array(
            [],
            dtype=float,
        )

        centers_primary = np.array(
            [],
            dtype=float,
        )

        primary_counts = np.array(
            [],
            dtype=int,
        )

    return {
        "barrier_force": barrier_force,
        "barrier_distance": barrier_distance,
        "barrier_x": barrier_x,
        "barrier_y": barrier_y,

        "primary_force": primary_force,
        "primary_distance": primary_distance,
        "primary_x": primary_x,
        "primary_y": primary_y,

        "lat1_grid": lat1_grid,
        "lat2_grid": lat2_grid,

        "barrier_grid_hist": barrier_grid_hist,
        "primary_grid_hist": primary_grid_hist,

        "barrier_grid_plot": barrier_grid_plot,
        "primary_grid_plot": primary_grid_plot,

        "low_barrier": low_barrier,
        "high_barrier": high_barrier,
        "low_primary": low_primary,
        "high_primary": high_primary,

        "edges_barrier": edges_barrier,
        "edges_primary": edges_primary,

        "centers_barrier": centers_barrier,
        "centers_primary": centers_primary,

        "barrier_counts": barrier_counts,
        "primary_counts": primary_counts,
        "has_barrier": has_barrier,
        "has_primary_minimum": has_primary_minimum,
    }

def _enable_histogram_hover(
    figure: Figure,
    axis,
    patches,
    counts: np.ndarray,
    bin_edges: np.ndarray,
) -> None:
    """Show a MATLAB-style histogram data tip when hovering over a bar."""

    marker, = axis.plot(
        [],
        [],
        marker="o",
        markersize=5,
        markerfacecolor="white",
        markeredgecolor="black",
        linestyle="None",
        zorder=12,
    )

    marker.set_visible(False)

    annotation = axis.annotate(
        "",
        xy=(0.0, 0.0),
        xytext=(0, 0),
        textcoords="offset points",
        ha="left",
        va="bottom",
        bbox={
            "boxstyle": "square,pad=0.4",
            "facecolor": "white",
            "edgecolor": "gray",
            "alpha": 0.97,
        },
        zorder=11,
    )

    annotation.set_visible(False)

    def update_data_tip(
        patch,
        bin_index: int,
    ) -> None:
        """Move the MATLAB-style marker and data box to a histogram bar."""

        x_center = (
            patch.get_x()
            + patch.get_width() / 2.0
        )

        y_top = patch.get_height()

        frequency = counts[bin_index]

        left_edge = bin_edges[bin_index]
        right_edge = bin_edges[bin_index + 1]

        marker.set_data(
            [x_center],
            [y_top],
        )

        marker.set_visible(True)

        annotation.xy = (
            x_center,
            y_top,
        )

        annotation.set_position(
            (0, 0)
        )

        annotation.set_text(
            f"Value {int(frequency)}\n"
            f"Bin edges "
            f"[{left_edge:.6e} {right_edge:.6e}]"
        )

        point_x_pixels, point_y_pixels = (
            axis.transData.transform(
                (
                    x_center,
                    y_top,
                )
            )
        )

        axes_bbox = axis.bbox

        horizontal_middle = (
            axes_bbox.x0
            + axes_bbox.x1
        ) / 2.0

        vertical_middle = (
            axes_bbox.y0
            + axes_bbox.y1
        ) / 2.0

        if point_x_pixels > horizontal_middle:
            annotation.set_ha("right")
        else:
            annotation.set_ha("left")

        if point_y_pixels > vertical_middle:
            annotation.set_va("top")
        else:
            annotation.set_va("bottom")

        annotation.set_visible(True)

    def hide_data_tip() -> None:
        """Hide the marker and annotation."""

        marker.set_visible(False)
        annotation.set_visible(False)

    def on_hover(event) -> None:
        """Display the data tip for the histogram bar under the cursor."""

        if event.inaxes != axis:
            if annotation.get_visible():
                hide_data_tip()
                figure.canvas.draw_idle()

            return

        for bin_index, patch in enumerate(patches):
            contains, _ = patch.contains(event)

            if contains:
                update_data_tip(
                    patch,
                    bin_index,
                )

                figure.canvas.draw_idle()
                return

        if annotation.get_visible():
            hide_data_tip()
            figure.canvas.draw_idle()

    figure.canvas.mpl_connect(
        "motion_notify_event",
        on_hover,
    )

def plot_barrier_histogram(
    analysis: dict[str, Any],
    *,
    show: bool = True,
) -> Figure | None:
    """Plot the AFM force-barrier histogram."""

    barrier_force = np.asarray(
        analysis["barrier_force"],
        dtype=float,
    )

    values = barrier_force[
        np.isfinite(barrier_force)
    ]

    edges = np.asarray(
        analysis["edges_barrier"],
        dtype=float,
    )

    if values.size == 0 or edges.size < 2:
        return None

    figure, axis = plt.subplots()

    counts, bin_edges, patches = axis.hist(
        values,
        bins=edges,
        color="r",
        edgecolor="black",
    )

    axis.set_title("Barrier")
    axis.set_xlabel("F(N)")
    axis.set_ylabel("Frequency")

    _enable_histogram_hover(
        figure,
        axis,
        patches,
        counts,
        bin_edges,
    )

    figure.tight_layout()

    if show:
        plt.show()

    return figure

def plot_primary_minimum_histogram(
    analysis: dict[str, Any],
    *,
    show: bool = True,
) -> Figure | None:
    """Plot the AFM primary-minimum histogram."""

    primary_force = np.asarray(
        analysis["primary_force"],
        dtype=float,
    )

    values = primary_force[
        np.isfinite(primary_force)
    ]

    edges = np.asarray(
        analysis["edges_primary"],
        dtype=float,
    )

    if values.size == 0 or edges.size < 2:
        return None

    figure, axis = plt.subplots()

    counts, bin_edges, patches = axis.hist(
        values,
        bins=edges,
        color="b",
        edgecolor="black",
    )

    axis.set_title(
        "Primary Minimum"
    )

    axis.set_xlabel("F(N)")
    axis.set_ylabel("Frequency")

    _enable_histogram_hover(
        figure,
        axis,
        patches,
        counts,
        bin_edges,
    )

    figure.tight_layout()

    if show:
        plt.show()

    return figure

def _enable_heatmap_hover(
    figure: Figure,
    axis,
    x_grid: np.ndarray,
    y_grid: np.ndarray,
    plot_grid: np.ndarray,
    data_grid: np.ndarray,
    *,
    hover_radius_pixels: float = 18.0,
) -> None:
    """Show a MATLAB-style data tip over real heatmap data points."""

    valid = (
        np.isfinite(x_grid)
        & np.isfinite(y_grid)
        & np.isfinite(plot_grid)
        & np.isfinite(data_grid)
    )

    x_values = x_grid[valid].reshape(-1)
    y_values = y_grid[valid].reshape(-1)

    plot_z_values = plot_grid[
        valid
    ].reshape(-1)

    data_z_values = data_grid[
        valid
    ].reshape(-1)

    if x_values.size == 0:
        return

    marker, = axis.plot(
        [],
        [],
        [],
        marker="o",
        markersize=6,
        markerfacecolor="white",
        markeredgecolor="black",
        linestyle="None",
        zorder=20,
    )

    marker.set_visible(False)

    annotation = axis.annotate(
        "",
        xy=(0.0, 0.0),
        xytext=(0, 0),
        textcoords="offset points",
        ha="left",
        va="bottom",
        bbox={
            "boxstyle": "square,pad=0.4",
            "facecolor": "white",
            "edgecolor": "gray",
            "alpha": 0.97,
        },
        zorder=21,
    )

    annotation.set_visible(False)

    def hide_data_tip() -> None:
        marker.set_visible(False)
        annotation.set_visible(False)

    def project_points():
        projected_x, projected_y, _ = (
            proj3d.proj_transform(
                x_values,
                y_values,
                plot_z_values,
                axis.get_proj(),
            )
        )

        projected_pixels = axis.transData.transform(
            np.column_stack(
                (
                    projected_x,
                    projected_y,
                )
            )
        )

        return (
            projected_x,
            projected_y,
            projected_pixels,
        )

    def update_data_tip(
        index: int,
        projected_x: np.ndarray,
        projected_y: np.ndarray,
        projected_pixels: np.ndarray,
    ) -> None:
        x_value = x_values[index]
        y_value = y_values[index]

        plot_z_value = plot_z_values[index]
        data_z_value = data_z_values[index]

        marker.set_data_3d(
            [x_value],
            [y_value],
            [plot_z_value],
        )

        marker.set_visible(True)

        annotation.xy = (
            projected_x[index],
            projected_y[index],
        )

        annotation.set_position(
            (0, 0)
        )

        annotation.set_text(
            f"X {x_value:.6e}\n"
            f"Y {y_value:.6e}\n"
            f"F {data_z_value:.6e}"
        )

        point_x_pixels = (
            projected_pixels[
                index,
                0,
            ]
        )

        point_y_pixels = (
            projected_pixels[
                index,
                1,
            ]
        )

        axes_bbox = axis.bbox

        horizontal_middle = (
            axes_bbox.x0
            + axes_bbox.x1
        ) / 2.0

        vertical_middle = (
            axes_bbox.y0
            + axes_bbox.y1
        ) / 2.0

        if point_x_pixels > horizontal_middle:
            annotation.set_ha(
                "right"
            )
        else:
            annotation.set_ha(
                "left"
            )

        if point_y_pixels > vertical_middle:
            annotation.set_va(
                "top"
            )
        else:
            annotation.set_va(
                "bottom"
            )

        annotation.set_visible(
            True
        )

    def on_hover(event) -> None:
        if (
            event.inaxes != axis
            or event.x is None
            or event.y is None
        ):
            if annotation.get_visible():
                hide_data_tip()
                figure.canvas.draw_idle()

            return

        (
            projected_x,
            projected_y,
            projected_pixels,
        ) = project_points()

        distances = np.hypot(
            projected_pixels[:, 0]
            - event.x,
            projected_pixels[:, 1]
            - event.y,
        )

        closest_index = int(
            np.argmin(
                distances
            )
        )

        if (
            distances[
                closest_index
            ]
            <= hover_radius_pixels
        ):
            update_data_tip(
                closest_index,
                projected_x,
                projected_y,
                projected_pixels,
            )

            figure.canvas.draw_idle()

        elif annotation.get_visible():
            hide_data_tip()
            figure.canvas.draw_idle()

    figure.canvas.mpl_connect(
        "motion_notify_event",
        on_hover,
    )

def plot_barrier_heatmap(
    analysis: dict[str, Any],
    *,
    show: bool = True,
) -> Figure | None:
    """Plot the spatial distribution of force barriers."""

    x_grid = np.asarray(
        analysis["lat1_grid"],
        dtype=float,
    )

    y_grid = np.asarray(
        analysis["lat2_grid"],
        dtype=float,
    )

    barrier_grid = np.asarray(
        analysis[
            "barrier_grid_plot"
        ],
        dtype=float,
    )

    barrier_data = np.asarray(
        analysis[
            "barrier_grid_hist"
        ],
        dtype=float,
    )

    finite = np.isfinite(
        barrier_grid
    )

    if not np.any(finite):
        return None

    figure = plt.figure()

    axis = figure.add_subplot(
        111,
        projection="3d",
    )

    surface = axis.plot_surface(
        x_grid,
        y_grid,
        barrier_grid,
        cmap="jet",
    )

    axis.set_xlabel("X(m)")
    axis.set_ylabel("Y(m)")
    axis.set_zlabel("F(N)")

    axis.set_title(
        "Barrier Heatmap"
    )

    figure.colorbar(
        surface,
        ax=axis,
    )

    z_min = float(
        np.nanmin(
            barrier_grid
        )
    )

    z_max = float(
        np.nanmax(
            barrier_grid
        )
    )

    z_min = max(
        z_min,
        1e-10,
    )

    if z_max > z_min:
        axis.set_zlim(
            z_min,
            z_max,
        )

        axis.set_zscale(
            "log"
        )

    _enable_heatmap_hover(
        figure,
        axis,
        x_grid,
        y_grid,
        barrier_grid,
        barrier_data,
    )

    figure.tight_layout()

    if show:
        plt.show()

    return figure

def plot_primary_minimum_heatmap(
    analysis: dict[str, Any],
    *,
    show: bool = True,
) -> Figure | None:
    """Plot the spatial distribution of primary-minimum forces."""

    x_grid = np.asarray(
        analysis["lat1_grid"],
        dtype=float,
    )

    y_grid = np.asarray(
        analysis["lat2_grid"],
        dtype=float,
    )

    primary_grid = np.asarray(
        analysis[
            "primary_grid_plot"
        ],
        dtype=float,
    )

    primary_data = np.asarray(
        analysis[
            "primary_grid_hist"
        ],
        dtype=float,
    )

    finite = np.isfinite(
        primary_grid
    )

    if not np.any(finite):
        return None

    figure = plt.figure()

    axis = figure.add_subplot(
        111,
        projection="3d",
    )

    surface = axis.plot_surface(
        x_grid,
        y_grid,
        primary_grid,
        cmap="jet",
    )

    axis.set_xlabel("X(m)")
    axis.set_ylabel("Y(m)")
    axis.set_zlabel("F(N)")

    axis.set_title(
        "Primary Minimum heatmap"
    )

    figure.colorbar(
        surface,
        ax=axis,
    )

    low_primary = float(
        analysis[
            "low_primary"
        ]
    )

    high_primary = float(
        analysis[
            "high_primary"
        ]
    )

    if (
        np.isfinite(
            low_primary
        )
        and np.isfinite(
            high_primary
        )
        and low_primary
        < high_primary
    ):
        axis.set_zlim(
            low_primary,
            high_primary,
        )

    _enable_heatmap_hover(
        figure,
        axis,
        x_grid,
        y_grid,
        primary_grid,
        primary_data,
    )

    figure.tight_layout()

    if show:
        plt.show()

    return figure

#     return figures
def plot_analysis_data(
    analysis: dict,
    *,
    show: bool = True,
) -> dict:
    """Create only analysis figures supported by detected extrema."""

    figures = {
        "barrier_histogram": plot_barrier_histogram(
            analysis,
            show=False,
        ),
        "barrier_heatmap": plot_barrier_heatmap(
            analysis,
            show=False,
        ),
        "primary_minimum_histogram": None,
        "primary_minimum_heatmap": None,
    }

    if analysis["has_primary_minimum"]:
        figures[
            "primary_minimum_histogram"
        ] = plot_primary_minimum_histogram(
            analysis,
            show=False,
        )

        figures[
            "primary_minimum_heatmap"
        ] = plot_primary_minimum_heatmap(
            analysis,
            show=False,
        )

    if show:
        plt.show()

    return figures
