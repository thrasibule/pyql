from quantlib.termstructures.default_term_structure cimport DefaultProbabilityTermStructure
from . cimport _interpolated_survivalprobability_curve as _isc

cimport quantlib.math.interpolation as intpl

cpdef enum Interpolator:
    Linear
    LogLinear
    BackwardFlat

cdef union TraitSurvivalProbability:
    _isc.InterpolatedSurvivalProbabilityCurve[intpl.Linear]* lin
    _isc.InterpolatedSurvivalProbabilityCurve[intpl.LogLinear]* loglin
    _isc.InterpolatedSurvivalProbabilityCurve[intpl.BackwardFlat]* backflat

cdef class InterpolatedHazardRateCurve(DefaultProbabilityTermStructure):
    cdef readonly Interpolator _interpolator # needed so that we can query original template type
    cdef TraitSurvivalProbability trait
