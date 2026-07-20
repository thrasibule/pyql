from quantlib.termstructures.default_term_structure cimport DefaultProbabilityTermStructure

cpdef enum Interpolator:
    """Interpolation method for curves.

    - **Linear**:       Linear interpolation
    - **LogLinear**:    Log-linear interpolation (exponential of linear)
    - **BackwardFlat**: Backward-flat (piecewise constant) interpolation
    """
    Linear
    LogLinear
    BackwardFlat

cdef class InterpolatedHazardRateCurve(DefaultProbabilityTermStructure):
    cdef readonly Interpolator _trait


cdef class InterpolatedZeroInflationCurve(ZeroInflationTermStructure):
    cdef readonly Interpolator _trait
