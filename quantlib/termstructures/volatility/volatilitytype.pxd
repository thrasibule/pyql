cdef extern from 'ql/termstructures/volatility/volatilitytype.hpp' namespace 'QuantLib' nogil:
    cpdef enum VolatilityType:
        """Volatility type: ShiftedLognormal (displaced log-normal) or Normal (Bachelier)."""
        ShiftedLognormal
        Normal
