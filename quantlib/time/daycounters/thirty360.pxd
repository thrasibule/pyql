from quantlib.time.daycounter cimport DayCounter

cdef class Thirty360(DayCounter):
    pass

cdef extern from 'ql/time/daycounters/thirty360.hpp' namespace 'QuantLib::Thirty360' nogil:
    cpdef enum Convention:
        """30/360 day count conventions.

        ==============  =============================================
        Value           Description
        ==============  =============================================
        USA             USA (NASD) convention
        BondBasis       Bond Basis convention
        European        European convention
        EurobondBasis   Eurobond Basis convention
        Italian         Italian convention
        German          German convention
        ISMA            ISMA convention
        ISDA            ISDA convention
        NASD            NASD convention (same as USA)
        ==============  =============================================
        """
        USA
        BondBasis
        European
        EurobondBasis
        Italian
        German
        ISMA
        ISDA
        NASD
