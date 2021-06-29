from quantlib.termstructures.yield_term_structure cimport YieldTermStructure
from . cimport _bootstraptraits as trait
from . cimport _piecewise_yield_curve as _pyc

cimport quantlib.math._interpolations as intpl

cdef class DiscountLinearPiecewiseYieldCurve(YieldTermStructure):
    cdef _pyc.PiecewiseYieldCurve[trait.Discount, intpl.Linear]* _curve

cdef class DiscountLogLinearPiecewiseYieldCurve(YieldTermStructure):
    cdef _pyc.PiecewiseYieldCurve[trait.Discount, intpl.LogLinear]* _curve

cdef class DiscountBackwardFlatPiecewiseYieldCurve(YieldTermStructure):
    cdef _pyc.PiecewiseYieldCurve[trait.Discount, intpl.BackwardFlat]* _curve

cdef class ZeroYieldLinearPiecewiseYieldCurve(YieldTermStructure):
    cdef _pyc.PiecewiseYieldCurve[trait.ZeroYield, intpl.Linear]* _curve

cdef class ZeroYieldLogLinearPiecewiseYieldCurve(YieldTermStructure):
    cdef _pyc.PiecewiseYieldCurve[trait.ZeroYield, intpl.LogLinear]* _curve

cdef class ZeroYieldBackwardFlatPiecewiseYieldCurve(YieldTermStructure):
    cdef _pyc.PiecewiseYieldCurve[trait.ZeroYield, intpl.BackwardFlat]* _curve

cdef class ForwardRateLinearPiecewiseYieldCurve(YieldTermStructure):
    cdef _pyc.PiecewiseYieldCurve[trait.ForwardRate, intpl.Linear]* _curve

cdef class ForwardRateLogLinearPiecewiseYieldCurve(YieldTermStructure):
    cdef _pyc.PiecewiseYieldCurve[trait.ForwardRate, intpl.LogLinear]* _curve

cdef class ForwardRateBackwardFlatPiecewiseYieldCurve(YieldTermStructure):
    cdef _pyc.PiecewiseYieldCurve[trait.ForwardRate, intpl.BackwardFlat]* _curve

