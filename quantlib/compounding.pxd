cdef extern from "ql/compounding.hpp" namespace "QuantLib" nogil:
    cpdef enum Compounding:
        """Compounding conventions for interest rate calculations.

        ================  ==========================================
        Value             Description
        ================  ==========================================
        Simple            Simple compounding (no compounding)
        Continuous        Continuous compounding
        Compounded        Compounded at a given frequency
        SimpleThenCompounded  Simple up to first period, then compounded
        CompoundedThenSimple  Compounded up to first period, then simple
        ================  ==========================================
        """
        Simple = 0
        Continuous = 1
        Compounded = 2
        SimpleThenCompounded
        CompoundedThenSimple
