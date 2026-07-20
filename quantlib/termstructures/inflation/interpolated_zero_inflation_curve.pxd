from quantlib.termstructures.inflation_term_structure cimport ZeroInflationTermStructure

cpdef enum Interpolator:
    """Interpolation method for curves.

    - **Linear**:       Linear interpolation
    - **LogLinear**:    Log-linear interpolation (exponential of linear)
    - **BackwardFlat**: Backward-flat (piecewise constant) interpolation
    """
    Linear
    LogLinear
    BackwardFlat

cdef class InterpolatedZeroInflationCurve(ZeroInflationTermStructure):
    cdef readonly Interpolator _trait
