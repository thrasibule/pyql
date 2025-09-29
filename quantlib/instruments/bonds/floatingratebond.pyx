from quantlib.types cimport Natural, Rate, Real, Spread
from cython.operator cimport dereference as deref
from libcpp.vector cimport vector
from libcpp cimport bool
from quantlib.handle cimport static_pointer_cast
from quantlib.indexes.ibor_index cimport IborIndex
cimport quantlib.indexes._ibor_index as _ii
from quantlib.time.businessdayconvention cimport BusinessDayConvention, Following, Unadjusted
from quantlib.time.date cimport Date, Period
from quantlib.time.calendar cimport Calendar
from quantlib.time.daycounter cimport DayCounter
from quantlib.time.schedule cimport Schedule
from quantlib.utilities.null cimport Null

from . cimport _floatingratebond as _frb

cdef class FloatingRateBond(Bond):
    """Floating-rate bond.

    This class represents a floating-rate bond, possibly with caps and/or floors.

    Parameters
    ----------
    settlement_days : int
        The number of settlement days.
    face_amount : float
        The face amount of the bond.
    schedule : :class:`~quantlib.time.schedule.Schedule`
        The bond's schedule.
    ibor_index : :class:`~quantlib.indexes.ibor_index.IborIndex`
        The underlying IBOR index.
    accrual_day_counter : :class:`~quantlib.time.daycounter.DayCounter`
        The accrual day counter.
    fixing_days : int, optional
        The number of fixing days.
    gearings : list of float, optional
        The gearing factors.
    spreads : list of float, optional
        The spreads over the index.
    caps : list of float, optional
        The caps on the coupon rate.
    floors : list of float, optional
        The floors on the coupon rate.
    payment_convention : :class:`~quantlib.time.businessdayconvention.BusinessDayConvention`, optional
        The payment business day convention.
    in_arrears : bool, optional
        Whether the coupon fixes in arrears.
    redemption : float, optional
        The redemption value.
    issue_date : :class:`~quantlib.time.date.Date`, optional
        The issue date of the bond.
    ex_coupon_period : :class:`~quantlib.time.date.Period`, optional
        The ex-coupon period.
    ex_coupon_calendar : :class:`~quantlib.time.calendar.Calendar`, optional
        The ex-coupon calendar.
    ex_coupon_convention : :class:`~quantlib.time.businessdayconvention.BusinessDayConvention`, optional
        The ex-coupon business day convention.
    ex_coupon_end_of_month : bool, optional
        Whether to use the end-of-month rule for ex-coupon dates.
    """
    def __init__(self, Natural settlement_days, Real face_amount,
                 Schedule schedule, IborIndex ibor_index,
                 DayCounter accrual_day_counter, Natural fixing_days=Null[Natural](),
                 vector[Real] gearings=[1.], vector[Spread] spreads=[0.],
                 vector[Rate] caps=[], vector[Rate] floors=[],
                 BusinessDayConvention payment_convention=Following,
                 bool in_arrears=False,
                 Real redemption=100.0, Date issue_date=Date(),
                 Period ex_coupon_period=Period(),
                 Calendar ex_coupon_calendar=Calendar(),
                 BusinessDayConvention ex_coupon_convention=Unadjusted,
                 bool ex_coupon_end_of_month=False
        ):

        self._thisptr.reset(
            new _frb.FloatingRateBond(
                settlement_days, face_amount,
                schedule._thisptr,
                static_pointer_cast[_ii.IborIndex](ibor_index._thisptr),
                deref(accrual_day_counter._thisptr),
                payment_convention,
                fixing_days, gearings, spreads, caps, floors, in_arrears,
                redemption,
                issue_date._thisptr,
                deref(ex_coupon_period._thisptr),
                ex_coupon_calendar._thisptr,
                ex_coupon_convention,
                ex_coupon_end_of_month
            )
        )
