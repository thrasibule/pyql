cdef extern from "ql/cashflows/duration.hpp" namespace "QuantLib::Duration" nogil:
    cpdef enum Duration "QuantLib::Duration::Type":
        """Duration type: Simple, Macaulay, or Modified."""
        Simple
        Macaulay
        Modified
