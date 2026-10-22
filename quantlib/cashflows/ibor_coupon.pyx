from quantlib.types cimport Integer, Natural, Rate, Real, Spread

from libcpp cimport bool
from libcpp.optional cimport optional
from libcpp.utility cimport move
from libcpp.vector cimport vector
from quantlib.time.businessdayconvention cimport BusinessDayConvention
from quantlib.time.calendar cimport Calendar
from quantlib.time.schedule cimport Schedule
from .._cashflow cimport Leg as QlLeg
from cython.operator cimport dereference as deref
from quantlib.ext cimport shared_ptr, static_pointer_cast, dynamic_pointer_cast
from quantlib.time.date cimport Date
from quantlib.time.daycounter cimport DayCounter
cimport quantlib.cashflows._ibor_coupon as _ic
from ..cashflow cimport CashFlow
from .. cimport _cashflow as _cf
cimport quantlib.indexes._ibor_index as _ii
from quantlib.indexes.ibor_index cimport IborIndex

cdef class IborCoupon(FloatingRateCoupon):

    def __init__(self, Date payment_date not None, Real nominal,
                 Date start_date not None, Date end_date not None,
                 Natural fixing_days, IborIndex index not None, Real gearing=1.,
                 Spread spread=0.,
                 Date ref_period_start=Date(), Date ref_period_end=Date(),
                 DayCounter day_counter=DayCounter(), bool is_in_arrears=False):
        self._thisptr.reset(
            new _ic.IborCoupon(
                payment_date._thisptr, nominal,
                start_date._thisptr, end_date._thisptr,
                fixing_days,
                static_pointer_cast[_ii.IborIndex](index._thisptr),
                gearing, spread,
                ref_period_start._thisptr, ref_period_end._thisptr,
                deref(day_counter._thisptr), is_in_arrears
            )
        )
    Settings = IborCouponSettings()

def as_ibor_coupon(CashFlow cf):
    cdef IborCoupon coupon = IborCoupon.__new__(IborCoupon)
    coupon._thisptr = dynamic_pointer_cast[_ic.IborCoupon](cf._thisptr)
    if not coupon._thisptr:
        return None
    else:
        return coupon

cdef class IborCouponSettings:
    @staticmethod
    def create_at_par_coupons():
        _ic.Settings.instance().createAtParCoupons()

    @staticmethod
    def create_indexed_coupons():
        _ic.Settings.instance().createIndexedCoupons()

    @staticmethod
    def using_at_par_coupons():
        return _ic.Settings.instance().usingAtParCoupons()

cdef class IborLeg(Leg):
    """A leg of Ibor coupons on a schedule, built like QuantLib's IborLeg:

    >>> leg = IborLeg(schedule, index).with_notionals(1.).with_spreads(0.02)()

    the ``with_*`` methods set the coupons' terms, and calling the object
    builds them. Capped or floored coupons need a pricer that can price
    the optionlets, e.g. ``set_coupon_pricer(leg, BlackIborCouponPricer(v))``.
    """

    def __init__(self, Schedule schedule not None, IborIndex index not None):
        self.leg = new _ic.IborLeg(schedule._thisptr,
                                   static_pointer_cast[_ii.IborIndex](index._thisptr))

    def __dealloc__(self):
        if self.leg is not NULL:
            del self.leg
            self.leg = NULL

    def with_notionals(self, Real notional):
        self.leg.withNotionals(notional)
        return self

    def with_payment_day_counter(self, DayCounter dc not None):
        self.leg.withPaymentDayCounter(deref(dc._thisptr))
        return self

    def with_payment_adjustment(self, BusinessDayConvention bdc):
        self.leg.withPaymentAdjustment(bdc)
        return self

    def with_payment_lag(self, Integer lag):
        self.leg.withPaymentLag(lag)
        return self

    def with_payment_calendar(self, Calendar cal not None):
        self.leg.withPaymentCalendar(cal._thisptr)
        return self

    def with_fixing_days(self, Natural fixing_days):
        self.leg.withFixingDays(fixing_days)
        return self

    def with_gearings(self, Real gearing):
        self.leg.withGearings(gearing)
        return self

    def with_spreads(self, spreads):
        cdef vector[Spread] c_spreads
        if isinstance(spreads, list):
            c_spreads = <list>spreads
            self.leg.withSpreads(c_spreads)
        else:
            self.leg.withSpreads(<Spread>spreads)
        return self

    def with_caps(self, caps):
        cdef vector[Rate] c_caps
        if isinstance(caps, list):
            c_caps = <list>caps
            self.leg.withCaps(c_caps)
        else:
            self.leg.withCaps(<Rate>caps)
        return self

    def with_floors(self, floors):
        cdef vector[Rate] c_floors
        if isinstance(floors, list):
            c_floors = <list>floors
            self.leg.withFloors(c_floors)
        else:
            self.leg.withFloors(<Rate>floors)
        return self

    def in_arrears(self, bool flag=True):
        self.leg.inArrears(flag)
        return self

    def with_zero_payments(self, bool flag=True):
        self.leg.withZeroPayments(flag)
        return self

    def with_indexed_coupons(self, flag=True):
        cdef optional[bool] b
        if flag is not None:
            b = <bool>flag
        self.leg.withIndexedCoupons(b)
        return self

    def with_at_par_coupons(self, bool flag=True):
        self.leg.withAtParCoupons(flag)
        return self

    def __call__(self):
        if self.leg is NULL:
            raise ValueError("this leg wasn't made with IborLeg(schedule, index)")
        self._thisptr = move[QlLeg](_ic.ibor_to_leg(deref(self.leg)))
        return self

    def __iter__(self):
        cdef shared_ptr[_cf.CashFlow] cf
        cdef IborCoupon ic = IborCoupon.__new__(IborCoupon)
        for cf in self._thisptr:
            ic._thisptr = cf
            yield ic

    def __repr__(self):
        """ Pretty print cash flow schedule. """

        header = "Cash Flow Schedule:\n"
        values = ("{0!s} {1:f}".format(ic.date, ic.amount) for ic in self)
        return header + '\n'.join(values)
