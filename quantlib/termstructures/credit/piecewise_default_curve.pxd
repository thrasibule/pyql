from ..default_term_structure cimport DefaultProbabilityTermStructure
from . cimport _piecewise_default_curve as _pdc
cimport quantlib.math.interpolation as intpl

cdef enum Interpolator:
    Linear
    LogLinear
    BackwardFlat

cdef enum ProbabilityTrait:
    HazardRate
    DefaultDensity
    SurvivalProbability

# typedef to shorten the code, not in QuantLib
ctypedef _pdc.PiecewiseDefaultCurve[_pdc.HazardRate,intpl.Linear] HR_LIN
ctypedef _pdc.PiecewiseDefaultCurve[_pdc.HazardRate,intpl.LogLinear] HR_LOGLIN
ctypedef _pdc.PiecewiseDefaultCurve[_pdc.HazardRate,intpl.BackwardFlat] HR_BACKFLAT
ctypedef _pdc.PiecewiseDefaultCurve[_pdc.DefaultDensity,intpl.Linear] DD_LIN
ctypedef _pdc.PiecewiseDefaultCurve[_pdc.DefaultDensity,intpl.LogLinear] DD_LOGLIN
ctypedef _pdc.PiecewiseDefaultCurve[_pdc.DefaultDensity,intpl.BackwardFlat] DD_BACKFLAT
ctypedef _pdc.PiecewiseDefaultCurve[_pdc.SurvivalProbability,intpl.Linear] SP_LIN
ctypedef _pdc.PiecewiseDefaultCurve[_pdc.SurvivalProbability,intpl.LogLinear] SP_LOGLIN
ctypedef _pdc.PiecewiseDefaultCurve[_pdc.SurvivalProbability,intpl.BackwardFlat] SP_BACKFLAT

cdef union CurveType:
    HR_LIN* hr_lin
    HR_LOGLIN* hr_loglin
    HR_BACKFLAT* hr_backflat
    DD_LIN* dd_lin
    DD_LOGLIN* dd_loglin
    DD_BACKFLAT* dd_backflat
    SP_LIN* sp_lin
    SP_LOGLIN* sp_loglin
    SP_BACKFLAT* sp_backflat

cdef class PiecewiseDefaultCurve(DefaultProbabilityTermStructure):
   cdef readonly ProbabilityTrait _trait
   cdef readonly Interpolator _interpolator
   cdef CurveType curve_type
