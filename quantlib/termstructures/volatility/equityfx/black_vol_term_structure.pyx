from cython.operator cimport dereference as deref
cimport _black_vol_term_structure as _bv


from quantlib.time.calendar cimport Calendar
from quantlib.time.date cimport Date
from quantlib.time.daycounter cimport DayCounter

cdef class BlackVolTermStructure:

    def __init__(self):
        raise ValueError(
            'BlackVolTermStructure cannot be directly instantiated!'
        )


cdef class BlackConstantVol(BlackVolTermStructure):

    def __init__(self,
        Date reference_date,
        Calendar calendar,
        double volatility,
        DayCounter daycounter
    ):

        self._thisptr = shared_ptr[_bv.BlackVolTermStructure](
            new _bv.BlackConstantVol(
                deref(reference_date._thisptr),
                deref(calendar._thisptr),
                volatility,
                deref(daycounter._thisptr)
            )
        )

