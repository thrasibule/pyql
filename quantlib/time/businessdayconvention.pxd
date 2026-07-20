cdef extern from "ql/time/businessdayconvention.hpp" namespace "QuantLib" nogil:
    cpdef enum BusinessDayConvention:
        """Business day conventions for adjusting non-business days.

        ==============================  ==========================================
        Value                           Description
        ==============================  ==========================================
        Following                       Roll on to the next business day
        ModifiedFollowing               Roll on to the next business day unless
                                        it falls in the next month, then roll back
        Preceding                       Roll back to the previous business day
        ModifiedPreceding               Roll back to the previous business day
                                        unless it falls in the previous month
        Unadjusted                      No adjustment
        HalfMonthModifiedFollowing      Modified Following at mid-month
        Nearest                         Roll to the nearest business day
        ==============================  ==========================================
        """
        Following
        ModifiedFollowing
        Preceding
        ModifiedPreceding
        Unadjusted
        HalfMonthModifiedFollowing
        Nearest
