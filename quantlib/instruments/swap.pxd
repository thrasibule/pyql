from ..instrument cimport Instrument

cdef extern from "ql/instruments/swap.hpp" namespace "QuantLib::Swap" nogil:
    cpdef enum class Type:
        """Swap type: Receiver (receives fixed, pays floating) or Payer (pays fixed, receives floating)."""
        Receiver
        Payer

cdef class Swap(Instrument):
    pass
