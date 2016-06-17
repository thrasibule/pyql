from cython.operator cimport dereference as deref
cimport _coupon_pricer as _cp
cimport quantlib.instruments._bonds as _bonds
from quantlib.termstructures.volatility.optionlet.optionlet_volatility_structure cimport OptionletVolatilityStructure
cimport quantlib.termstructures.volatility.optionlet._optionlet_volatility_structure as _ovs
from quantlib.handle cimport Handle
from quantlib.time.calendar cimport Calendar
from quantlib.time.date cimport Date
from quantlib.time.daycounter cimport DayCounter
from coupon_pricer cimport FloatingRateCouponPricer
from quantlib.cashflow cimport Leg
from quantlib.instruments.bonds cimport Bond
cimport quantlib._cashflow as _cf
cdef class IborCouponPricer:

    def __init__(self):
        raise ValueError(
            'IborCouponPricer cannot be directly instantiated!'
        )

cdef class BlackIborCouponPricer(IborCouponPricer):

    def __init__(self,
        OptionletVolatilityStructure ovs
    ):
        cdef Handle[_ovs.OptionletVolatilityStructure] ovs_handle = \
                Handle[_ovs.OptionletVolatilityStructure](deref(ovs._thisptr))
        self._thisptr = shared_ptr[_cp.FloatingRateCouponPricer](
            new _cp.BlackIborCouponPricer(ovs_handle)
        )

def set_coupon_pricer(Bond frb, pricer):
    """ Parameters :
        ----------
        1) frb : FloatingRateBond  
            Bond object to be used to extract cashflows
        2) pricer : FloatingRateCouponPricer 
            BlackIborCouponPricer has been exposed"""
    bond_leg = (<_bonds.Bond*>frb._thisptr.get()).cashflows()
    _cp.setCouponPricer(bond_leg,
                        (<FloatingRateCouponPricer>pricer)._thisptr)


