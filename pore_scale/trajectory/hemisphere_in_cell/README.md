# Hemisphere-in-Cell Trajectory Simulation

A Fortran trajectory simulation code for the hemisphere-in-cell collector
geometry (Ma et al., 2009) is available in this directory. This geometry
includes grain-to-grain contacts with grain centers oriented perpendicular
to flow and uses a numerical (rather than analytical) flow field.

> ⚠️ **Not recommended for general use.** This code is significantly more
> complex than the Happel, impinging jet, and parallel plate codes, and has
> limited documentation and testing. It is provided for completeness and for
> users with specific research needs requiring grain-to-grain contacts with
> a numerical flow field. Users interested in grain-to-grain contact effects
> are encouraged to start with the dense cubic packing code, which uses an
> analytical flow field and is better documented.

For questions about this code please contact the authors directly:
william.johnson@utah.edu

---

## Reference

- Ma, H., Hradisky, M., and Johnson, W.P. (2009). Extending applicability of
  correlation equations to predict colloidal retention in porous media at low
  fluid velocity. *Environmental Science & Technology*, 47(5), 2272–2278.
  https://doi.org/10.1021/es304124p

