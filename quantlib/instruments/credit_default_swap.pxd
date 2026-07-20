from ..instrument cimport Instrument

cdef extern from 'ql/instruments/creditdefaultswap.hpp' namespace 'QuantLib::CreditDefaultSwap':
    cpdef enum class PricingModel:
        """CDS pricing model: Midpoint (standard market model) or ISDA (ISDA standard model)."""
        Midpoint
        ISDA

cdef class CreditDefaultSwap(Instrument):
    pass
