from cython.operator cimport dereference as deref

from quantlib.types cimport Natural, Real, Rate
from quantlib.time.businessdayconvention cimport BusinessDayConvention, Following, Unadjusted
from quantlib.time.calendar cimport Calendar
from quantlib.time.date cimport Period, Date
from quantlib.time.daycounter cimport DayCounter
from quantlib.time.schedule cimport Schedule

from libcpp cimport bool
from libcpp.vector cimport vector
from . cimport _fixedratebond as _frb

cdef class FixedRateBond(Bond):
    """Fixed-rate bond.

    Parameters
    ----------
    settlement_days : int
        The number of settlement days.
    face_amount : float
        The face amount of the bond.
    schedule : :class:`~quantlib.time.schedule.Schedule`
        The bond's schedule.
    coupons : list of float
        The coupon rates.
    accrual_day_counter : :class:`~quantlib.time.daycounter.DayCounter`
        The accrual day counter.
    payment_convention : :class:`~quantlib.time.businessdayconvention.BusinessDayConvention`, optional
        The payment business day convention.
    redemption : float, optional
        The redemption value.
    issue_date : :class:`~quantlib.time.date.Date`, optional
        The issue date of the bond.
    payment_calendar : :class:`~quantlib.time.calendar.Calendar`, optional
        The payment calendar.
    ex_coupon_period : :class:`~quantlib.time.date.Period`, optional
        The ex-coupon period.
    ex_coupon_calendar : :class:`~quantlib.time.calendar.Calendar`, optional
        The ex-coupon calendar.
    ex_coupon_convention : :class:`~quantlib.time.businessdayconvention.BusinessDayConvention`, optional
        The ex-coupon business day convention.
    ex_coupon_end_of_month : bool, optional
        Whether to use the end-of-month rule for ex-coupon dates.
    first_period_day_counter : :class:`~quantlib.time.daycounter.DayCounter`, optional
        The day counter for the first coupon period.
    """

    def __init__(self, Natural settlement_days, Real face_amount,
                 Schedule schedule, vector[Rate] coupons,
                 DayCounter accrual_day_counter,
                 BusinessDayConvention payment_convention=Following,
                 Real redemption=100.0, Date issue_date=Date(),
                 Calendar payment_calendar=Calendar(),
                 Period ex_coupon_period=Period(),
                 Calendar ex_coupon_calendar=Calendar(),
                 BusinessDayConvention ex_coupon_convention=Unadjusted,
                 bool ex_coupon_end_of_month=False,
                 DayCounter first_period_day_counter=DayCounter()):

        self._thisptr.reset(
            new _frb.FixedRateBond(
                settlement_days,
                face_amount,
                schedule._thisptr,
                coupons,
                deref(accrual_day_counter._thisptr),
                payment_convention,
                redemption, issue_date._thisptr,
                payment_calendar._thisptr,
                deref(ex_coupon_period._thisptr),
                ex_coupon_calendar._thisptr,
                ex_coupon_convention,
                ex_coupon_end_of_month,
                deref(first_period_day_counter._thisptr)
            )
        )
