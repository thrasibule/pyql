from .black_vol_term_structure cimport BlackVarianceTermStructure

cdef extern from 'ql/termstructures/volatility/equityfx/blackvariancesurface.hpp' namespace 'QuantLib::BlackVarianceSurface':
    cpdef enum Extrapolation:
        """Extrapolation method: ConstantExtrapolation (flat) or InterpolatorDefaultExtrapolation (uses interpolator)."""
        ConstantExtrapolation
        InterpolatorDefaultExtrapolation

cdef class BlackVarianceSurface(BlackVarianceTermStructure):
    pass
