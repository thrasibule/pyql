from cython.operator cimport dereference as deref
from quantlib.ext cimport shared_ptr
from quantlib.time.date cimport Date, date_from_qldate
cimport quantlib.time._date as _date
from quantlib.time.daycounter cimport DayCounter
cimport quantlib.time._daycounter as _dc
cimport quantlib._cashflow as _cf

cdef class Coupon(CashFlow):
    """Base class for coupon accruals.

    A Coupon is a cash flow that also carries information about
    accrual periods (start/end dates, accrual days, rate) and a
    day counter for computing accrued amounts.

    This is the base class for concrete coupon types:

    - :class:`FixedRateCoupon` — fixed rate coupons
    - :class:`FloatingRateCoupon` — floating rate coupons
    - :class:`IborCoupon` — Ibor-indexed coupons
    - :class:`CmsCoupon` — CMS-indexed coupons
    - :class:`CpiCoupon` — CPI-linked coupons
    """

    cdef inline _coupon.Coupon* _get_coupon(self) noexcept:
        return <_coupon.Coupon*>self._thisptr.get()

    @property
    def nominal(self):
        """Returns the nominal amount of the coupon.

        Returns
        -------
        float
        """
        return self._get_coupon().nominal()

    @property
    def accrual_start_date(self):
        """Returns the start date of the accrual period.

        Returns
        -------
        :class:`~quantlib.time.date.Date`
        """
        return date_from_qldate(
            self._get_coupon().accrualStartDate())

    @property
    def accrual_end_date(self):
        """Returns the end date of the accrual period.

        Returns
        -------
        :class:`~quantlib.time.date.Date`
        """
        return date_from_qldate(
            self._get_coupon().accrualEndDate())

    @property
    def reference_period_start(self):
        """Returns the start date of the reference period.

        Returns
        -------
        :class:`~quantlib.time.date.Date`
        """
        return date_from_qldate(
            self._get_coupon().referencePeriodStart())

    @property
    def reference_period_end(self):
        """Returns the end date of the reference period.

        Returns
        -------
        :class:`~quantlib.time.date.Date`
        """
        return date_from_qldate(
            self._get_coupon().referencePeriodEnd())

    @property
    def accrual_days(self):
        """Returns the number of days in the accrual period.

        Returns
        -------
        int
        """
        return self._get_coupon().accrualDays()

    @property
    def accrual_period(self):
        """Returns the length of the accrual period as a year fraction.

        Returns
        -------
        float
        """
        return self._get_coupon().accrualPeriod()

    def accrued_period(self, Date date):
        """Returns the fraction of the accrual period that has passed.

        Parameters
        ----------
        date : :class:`~quantlib.time.date.Date`
            The date up to which to compute the accrued period.

        Returns
        -------
        float
        """
        return self._get_coupon().accruedPeriod(date._thisptr)

    def accrued_days(self, Date date):
        """Returns the number of accrued days.

        Parameters
        ----------
        date : :class:`~quantlib.time.date.Date`
            The date up to which to compute the accrued days.

        Returns
        -------
        int
        """
        return self._get_coupon().accruedDays(date._thisptr)

    def accrued_amount(self, Date date):
        """Returns the accrued amount up to the given date.

        Parameters
        ----------
        date : :class:`~quantlib.time.date.Date`
            The date up to which to compute the accrued amount.

        Returns
        -------
        float
        """
        return self._get_coupon().accruedAmount(date._thisptr)

    @property
    def rate(self):
        """Returns the coupon rate.

        Returns
        -------
        float
        """
        return self._get_coupon().rate()

    @property
    def day_counter(self):
        """Returns the day counter of the coupon.

        Returns
        -------
        :class:`~quantlib.time.daycounter.DayCounter`
        """
        cdef DayCounter dc = DayCounter.__new__(DayCounter)
        dc._thisptr = new _dc.DayCounter(self._get_coupon().dayCounter())
        return dc

def as_coupon(CashFlow cf):
    """Casts a CashFlow to a Coupon.

    Parameters
    ----------
    cf : :class:`~quantlib.cashflow.CashFlow`
        The cash flow to cast.

    Returns
    -------
    :class:`Coupon`
    """
    cdef Coupon coupon = Coupon.__new__(Coupon)
    coupon._thisptr = cf._thisptr
    return coupon
