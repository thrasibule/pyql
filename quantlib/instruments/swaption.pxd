from . cimport _swaption
from ..option cimport Option

cdef extern from "ql/instruments/swaption.hpp" namespace "QuantLib::Settlement":
    cpdef enum class Method "QuantLib::Settlement::Method":
        """Settlement method: PhysicalOTC, PhysicalCleared, CollateralizedCashPrice, or ParYieldCurve."""
        PhysicalOTC
        PhysicalCleared
        CollateralizedCashPrice
        ParYieldCurve

    cpdef enum class Type "QuantLib::Settlement::Type":
        """Settlement type: Physical (delivery) or Cash (cash settlement)."""
        Physical
        Cash

cdef class Swaption(Option):
    cdef inline _swaption.Swaption* get_swaption(self) noexcept nogil
