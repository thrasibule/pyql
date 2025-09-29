from cython.operator cimport dereference as deref

from quantlib.types cimport Natural, Real
from quantlib.time.businessdayconvention cimport BusinessDayConvention, Following
from quantlib.time.calendar cimport Calendar
from quantlib.time.date cimport Date

from . cimport _zerocouponbond as _zcb

cdef class ZeroCouponBond(Bond):
    """Zero-coupon bond.

    Parameters
    ----------
    settlement_days : int
        The number of settlement days.
    calendar : :class:`~quantlib.time.calendar.Calendar`
        The calendar for the bond.
    face_amount : float
        The face amount of the bond.
    maturity_date : :class:`~quantlib.time.date.Date`
        The maturity date of the bond.
    payment_convention : :class:`~quantlib.time.businessdayconvention.BusinessDayConvention`, optional
        The payment business day convention.
    redemption : float, optional
        The redemption value.
    issue_date : :class:`~quantlib.time.date.Date`, optional
        The issue date of the bond.
    """
    def __init__(self, Natural settlement_days, Calendar calendar,
                 Real face_amount, Date maturity_date,
                 BusinessDayConvention payment_convention=Following,
                 Real redemption=100.0, Date issue_date=Date()):

        self._thisptr.reset(
            new _zcb.ZeroCouponBond(
                settlement_days, calendar._thisptr,
                face_amount,
                maturity_date._thisptr,
                payment_convention, redemption,
                issue_date._thisptr
            )
        )
