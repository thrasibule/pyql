from cython.operator cimport dereference as deref
from . cimport _optionlet_volatility_structure as _ov

from quantlib.time._calendar cimport BusinessDayConvention
from quantlib.time.calendar cimport Calendar
from quantlib.time.date cimport Date
from quantlib.time.daycounter cimport DayCounter
from quantlib.termstructures.volatility.volatilitytype cimport VolatilityType


cdef class OptionletVolatilityStructure:

    @property
    def volatility_type(self):
        """ShiftedLognormal or Normal"""
        return self._thisptr.get().volatilityType()

    @property
    def displacement(self):
        """the shift of shifted lognormal volatilities"""
        return self._thisptr.get().displacement()


cdef class ConstantOptionletVolatility(OptionletVolatilityStructure):

    def __init__(self,
        int settlement_days,
        Calendar calendar,
        BusinessDayConvention bdc,
        double volatility,
        DayCounter daycounter,
        VolatilityType vol_type=VolatilityType.ShiftedLognormal,
        double displacement=0.0,
    ):
        """the same volatility for every optionlet: shifted lognormal (by
        displacement) by default, or normal (Bachelier) with vol_type=Normal"""

        self._thisptr = shared_ptr[_ov.OptionletVolatilityStructure](
            new _ov.ConstantOptionletVolatility(
                settlement_days,
                calendar._thisptr,
                bdc,
                volatility,
                deref(daycounter._thisptr),
                vol_type,
                displacement,
            )
        )
