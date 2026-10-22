from quantlib.types cimport Real
from libcpp cimport bool
from quantlib.handle cimport Handle, HandleOptionletVolatilityStructure
from . cimport _overnight_indexed_coupon_pricer as _oicp


cdef class CompoundingOvernightIndexedCouponPricer(OvernightIndexedCouponPricer):
     def __init__(self):
         self._thisptr.reset(new _oicp.CompoundingOvernightIndexedCouponPricer())

cdef class ArithmeticAveragedOvernightIndexedCouponPricer(OvernightIndexedCouponPricer):
    def __init__(self, Real mean_reversion = 0.03, Real volatility=0.0, bool by_approx=False, HandleOptionletVolatilityStructure v = HandleOptionletVolatilityStructure(), bool effective_volatility_input = False):
        """ pricer for arithmetically averaged overnight indexed coupons

        Reference: Katsumi Takada 2011, Valuation of Arithmetically Average of
        Fed Funds Rates and Construction of the US Dollar Swap Yield Curve"""

        self._thisptr.reset(
            new _oicp.ArithmeticAveragedOvernightIndexedCouponPricer(
                mean_reversion,
                volatility,
                by_approx,
                v.handle(),
                effective_volatility_input
            )
        )

cdef class BlackCompoundingOvernightIndexedCouponPricer(CompoundingOvernightIndexedCouponPricer):
    def __init__(self, HandleOptionletVolatilityStructure v not None, bool effective_volatility_input=False):
        """pricer for compounded overnight indexed coupons that can be capped
        or floored, the optionlets priced with Black's formula (or Bachelier's
        for normal volatilities) on the optionlet volatilities v

        The caps and floors of the coupons of an :class:`OvernightLeg` need
        it: the plain compounding pricer can't price them."""
        self._thisptr.reset(
            new _oicp.BlackCompoundingOvernightIndexedCouponPricer(
                v.handle(), effective_volatility_input
            )
        )


cdef class BlackAveragingOvernightIndexedCouponPricer(ArithmeticAveragedOvernightIndexedCouponPricer):
    def __init__(self, HandleOptionletVolatilityStructure v not None, bool effective_volatility_input=False):
        """pricer for arithmetically averaged overnight indexed coupons that
        can be capped or floored, the optionlets priced on the optionlet
        volatilities v"""
        self._thisptr.reset(
            new _oicp.BlackAveragingOvernightIndexedCouponPricer(
                v.handle(), effective_volatility_input
            )
        )
