from quantlib.types cimport Natural, Real, Spread
from libcpp cimport bool
from cython.operator cimport dereference as deref
from quantlib.ext cimport shared_ptr, static_pointer_cast, dynamic_pointer_cast
from quantlib.handle cimport HandleYieldTermStructure
from quantlib.time.date cimport Date, date_from_qldate
from quantlib.time.daycounter cimport DayCounter
from .coupon_pricer cimport FloatingRateCouponPricer
cimport quantlib._cashflow as _cf
from ..cashflow cimport CashFlow
from quantlib.indexes.interest_rate_index cimport InterestRateIndex
cimport quantlib.indexes._interest_rate_index as _iri
from quantlib._index cimport Index

cdef class FloatingRateCoupon(Coupon):
    """Floating-rate coupon.

    A coupon whose rate is determined by an interest rate index fixing
    (e.g., LIBOR, EURIBOR, SOFR) plus an optional spread, multiplied
    by a gearing factor.

    Parameters
    ----------
    payment_date : :class:`~quantlib.time.date.Date`
        The payment date.
    nominal : float
        The nominal amount.
    start_date : :class:`~quantlib.time.date.Date`
        The start date of the accrual period.
    end_date : :class:`~quantlib.time.date.Date`
        The end date of the accrual period.
    fixing_days : int
        Number of business days before the start of the accrual
        period when the index is fixed.
    index : :class:`~quantlib.indexes.interest_rate_index.InterestRateIndex`
        The interest rate index used to determine the coupon rate.
    gearing : float, optional
        Multiplicative factor applied to the index fixing. Default is 1.
    spread : float, optional
        Additive spread applied to the rate. Default is 0.
    ref_period_start : :class:`~quantlib.time.date.Date`, optional
        Start date of the reference period.
    ref_period_end : :class:`~quantlib.time.date.Date`, optional
        End date of the reference period.
    day_counter : :class:`~quantlib.time.daycounter.DayCounter`, optional
        Day counter for accrual calculation.
    is_in_arrears : bool, optional
        If ``True``, the rate is set at the end of the accrual period
        (in arrears). Default is ``False``.
    """

    def __init__(self, Date payment_date not None, Real nominal,
                 Date start_date not None, Date end_date not None, Natural fixing_days,
                 InterestRateIndex index not None, Real gearing=1., Spread spread=0.,
                 Date ref_period_start=Date(), Date ref_period_end=Date(),
                 DayCounter day_counter=DayCounter(), bool is_in_arrears=False):
        self._thisptr = shared_ptr[_cf.CashFlow](
            new _frc.FloatingRateCoupon(
                payment_date._thisptr, nominal,
                start_date._thisptr, end_date._thisptr,
                fixing_days,
                static_pointer_cast[_iri.InterestRateIndex](index._thisptr),
                gearing, spread,
                ref_period_start._thisptr, ref_period_end._thisptr,
                deref(day_counter._thisptr), is_in_arrears)
        )

    cdef inline _frc.FloatingRateCoupon* _get_frc(self) noexcept:
        return <_frc.FloatingRateCoupon*>self._thisptr.get()

    def set_pricer(self, FloatingRateCouponPricer pricer not None):
        """Sets the pricer used to compute the coupon rate.

        Parameters
        ----------
        pricer : :class:`~quantlib.cashflows.coupon_pricer.FloatingRateCouponPricer`
            The pricer to use.
        """
        self._get_frc().setPricer(pricer._thisptr)

    @property
    def fixing_days(self):
        """Returns the number of fixing days.

        Returns
        -------
        int
        """
        return self._get_frc().fixingDays()

    @property
    def gearing(self):
        """Returns the gearing (multiplicative factor).

        Returns
        -------
        float
        """
        return self._get_frc().gearing()

    @property
    def spread(self):
        """Returns the spread.

        Returns
        -------
        float
        """
        return self._get_frc().spread()

    @property
    def fixing_date(self):
        """Returns the fixing date.

        Returns
        -------
        :class:`~quantlib.time.date.Date`
        """
        return date_from_qldate(self._get_frc().fixingDate())

    @property
    def index(self):
        """Returns the interest rate index.

        Returns
        -------
        :class:`~quantlib.indexes.interest_rate_index.InterestRateIndex`
        """
        cdef InterestRateIndex r = InterestRateIndex.__new__(InterestRateIndex)
        r._thisptr = self._get_frc().index()
        return r

    @property
    def index_fixing(self):
        """Returns the index fixing.

        Returns
        -------
        float
        """
        return self._get_frc().indexFixing()

    @property
    def convexity_adjustment(self):
        """Returns the convexity adjustment.

        Returns
        -------
        float
        """
        return self._get_frc().convexityAdjustment()

    @property
    def adjusted_fixing(self):
        """Returns the adjusted fixing (with gearing, spread, and
        convexity adjustment).

        Returns
        -------
        float
        """
        return self._get_frc().adjustedFixing()

    @property
    def is_in_arrears(self):
        """Returns whether the coupon is paid in arrears.

        Returns
        -------
        bool
        """
        return self._get_frc().isInArrears()

    def price(self, HandleYieldTermStructure discountingCurve):
        """Returns the price of the floating-rate coupon.

        Parameters
        ----------
        discountingCurve : :class:`~quantlib.handle.HandleYieldTermStructure`
            The discounting curve used for pricing.

        Returns
        -------
        float
        """
        return self._get_frc().price(discountingCurve.handle())

def as_floating_rate_coupon(CashFlow cf):
    """Casts a CashFlow to a FloatingRateCoupon.

    Parameters
    ----------
    cf : :class:`~quantlib.cashflow.CashFlow`
        The cash flow to cast.

    Returns
    -------
    :class:`FloatingRateCoupon` or None
        Returns None if the cast fails.
    """
    cdef FloatingRateCoupon coupon = FloatingRateCoupon.__new__(FloatingRateCoupon)
    coupon._thisptr = dynamic_pointer_cast[_frc.FloatingRateCoupon](cf._thisptr)
    if not coupon._thisptr:
        return None
    else:
        return coupon
