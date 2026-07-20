from quantlib.types cimport Rate, Real
from cython.operator cimport dereference as deref, preincrement as preinc
from libcpp.vector cimport vector
from libcpp.utility cimport move
from quantlib.compounding cimport Compounding
from quantlib.ext cimport shared_ptr, dynamic_pointer_cast
from quantlib.time.businessdayconvention cimport BusinessDayConvention
from quantlib.time.calendar cimport Calendar
from quantlib.time.date cimport Date
from quantlib.time.frequency cimport Frequency, Annual
from quantlib.time.daycounter cimport DayCounter
from quantlib.time.schedule cimport Schedule
cimport quantlib._cashflow as _cf
from quantlib.interest_rate cimport InterestRate
from ..cashflow cimport CashFlow
from .._cashflow cimport Leg as QlLeg
cimport quantlib._interest_rate as _ir

cdef class FixedRateCoupon(Coupon):
    """Fixed-rate coupon.

    A coupon that pays a fixed interest rate on a nominal amount over
    an accrual period.

    Parameters
    ----------
    payment_date : :class:`~quantlib.time.date.Date`
        The payment date.
    nominal : float
        The nominal amount.
    rate : float
        The fixed interest rate.
    day_counter : :class:`~quantlib.time.daycounter.DayCounter`
        The day counter for accrual calculation.
    accrual_start_date : :class:`~quantlib.time.date.Date`
        The start date of the accrual period.
    accrual_end_date : :class:`~quantlib.time.date.Date`
        The end date of the accrual period.
    ref_period_start : :class:`~quantlib.time.date.Date`, optional
        The start date of the reference period.
    ref_period_end : :class:`~quantlib.time.date.Date`, optional
        The end date of the reference period.
    ex_coupon_date : :class:`~quantlib.time.date.Date`, optional
        The ex-coupon date.
    """

    def __init__(self, Date payment_date not None, Real nominal, Rate rate,
                 DayCounter day_counter not None, Date accrual_start_date not None,
                 Date accrual_end_date not None, Date ref_period_start=Date(),
                 Date ref_period_end=Date(), Date ex_coupon_date=Date()):
        self._thisptr = shared_ptr[_cf.CashFlow](
            new _frc.FixedRateCoupon(payment_date._thisptr, nominal,
                                     rate, deref(day_counter._thisptr),
                                     accrual_start_date._thisptr,
                                     accrual_end_date._thisptr,
                                     ref_period_start._thisptr,
                                     ref_period_end._thisptr,
                                     ex_coupon_date._thisptr)
            )

    def interest_rate(self):
        """Returns the interest rate of the fixed-rate coupon.

        Returns
        -------
        :class:`~quantlib.interest_rate.InterestRate`
        """
        cdef InterestRate ir = InterestRate.__new__(InterestRate)
        ir._thisptr = (<_frc.FixedRateCoupon*>self._thisptr.get()).interestRate()
        return ir

def as_fixed_rate_coupon(CashFlow cf):
    """Casts a CashFlow to a FixedRateCoupon.

    Parameters
    ----------
    cf : :class:`~quantlib.cashflow.CashFlow`
        The cash flow to cast.

    Returns
    -------
    :class:`FixedRateCoupon` or None
        Returns None if the cast fails.
    """
    cdef FixedRateCoupon coupon = FixedRateCoupon.__new__(FixedRateCoupon)
    coupon._thisptr = dynamic_pointer_cast[_frc.FixedRateCoupon](cf._thisptr)
    if not coupon._thisptr:
        return None
    else:
        return coupon


cdef class FixedRateLeg(Leg):
    """Helper class for building a sequence of fixed-rate coupons.

    This class implements the builder pattern for creating a leg of
    fixed-rate coupons. Configure the leg with the desired parameters,
    then call the instance to build the leg.

    Parameters
    ----------
    schedule : :class:`~quantlib.time.schedule.Schedule`
        The payment schedule.
    """

    def __init__(self, Schedule schedule):
        self.frl = new _frc.FixedRateLeg(schedule._thisptr)

    def with_notional(self, Real notional):
        """Sets the notional amount for all coupons.

        Parameters
        ----------
        notional : float
            The notional amount.

        Returns
        -------
        :class:`FixedRateLeg`
            Self, for method chaining.
        """
        self.frl.withNotionals(notional)
        return self

    def with_coupon_rates(self, Rate rate, DayCounter payment_day_counter, Compounding comp=Compounding.Simple, Frequency freq=Annual):
        """Sets the coupon rates for all coupons.

        Parameters
        ----------
        rate : float
            The fixed rate.
        payment_day_counter : :class:`~quantlib.time.daycounter.DayCounter`
            The day counter for payment calculation.
        comp : :class:`~quantlib.compounding.Compounding`, optional
            Compounding convention. Defaults to ``Simple``.
        freq : :class:`~quantlib.time.frequency.Frequency`, optional
            Compounding frequency. Defaults to ``Annual``.

        Returns
        -------
        :class:`FixedRateLeg`
            Self, for method chaining.
        """
        self.frl.withCouponRates(rate, deref(payment_day_counter._thisptr), comp, freq)
        return self

    def with_payment_adjustment(self, BusinessDayConvention bdc):
        """Sets the business day convention for payment adjustment.

        Parameters
        ----------
        bdc : int
            Business day convention.

        Returns
        -------
        :class:`FixedRateLeg`
            Self, for method chaining.
        """
        self.frl.withPaymentAdjustment(bdc)
        return self

    def with_payment_calendar(self, Calendar cal):
        """Sets the calendar for payment adjustment.

        Parameters
        ----------
        cal : :class:`~quantlib.time.calendar.Calendar`
            The calendar.

        Returns
        -------
        :class:`FixedRateLeg`
            Self, for method chaining.
        """
        self.frl.withPaymentCalendar(cal._thisptr)
        return self

    def with_last_period_day_counter(self, DayCounter dc):
        """Sets the day counter for the last period.

        Parameters
        ----------
        dc : :class:`~quantlib.time.daycounter.DayCounter`
            The day counter.

        Returns
        -------
        :class:`FixedRateLeg`
            Self, for method chaining.
        """
        self.frl.withLastPeriodDayCounter(deref(dc._thisptr))
        return self

    def __call__(self):
        """Builds and returns the fixed-rate leg.

        Returns
        -------
        :class:`FixedRateLeg`
            Self, containing the built leg.
        """
        self._thisptr = move[QlLeg](_frc.to_leg(deref(self.frl)))
        return self

    def __iter__(self):
        cdef FixedRateCoupon frc
        cdef vector[shared_ptr[_cf.CashFlow]].iterator it = self._thisptr.begin()
        while it != self._thisptr.end():
            frc = FixedRateCoupon.__new__(FixedRateCoupon)
            frc._thisptr = deref(it)
            yield frc
            preinc(it)
