from quantlib.time.daycounter cimport DayCounter


cdef class ActualActual(DayCounter):
    pass

cdef extern from 'ql/time/daycounters/actualactual.hpp' namespace 'QuantLib::ActualActual':
    cpdef enum Convention:
        """Actual/Actual day count conventions.

        ==========  =============================================
        Value       Description
        ==========  =============================================
        ISMA        ISMA (Bond) convention
        Bond        Bond convention (same as ISMA)
        ISDA        ISDA convention
        Historical  Historical convention
        Actual365   Actual/365 (Canadian) convention
        AFB         AFB (French) convention
        Euro        Euro convention
        ==========  =============================================
        """
        ISMA
        Bond
        ISDA
        Historical
        Actual365
        AFB
        Euro
