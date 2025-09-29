from cython.operator cimport dereference as deref
from quantlib.types cimport Natural, Rate, Real
from libcpp cimport bool
from libcpp.vector cimport vector
from . cimport _cpibond

from quantlib.handle cimport static_pointer_cast
cimport quantlib.indexes._inflation_index as _inf
from quantlib.indexes.inflation_index cimport ZeroInflationIndex
from quantlib.time.businessdayconvention cimport BusinessDayConvention, Following, Unadjusted
from quantlib.time.calendar cimport Calendar
from quantlib.time.schedule cimport Schedule
from quantlib.time.date cimport Date, Period
from quantlib.time.daycounter cimport DayCounter

cdef class CPIBond(Bond):
    """CPI-linked bond.

    This class represents a CPI-linked bond, also known as an
    inflation-indexed bond.

    Parameters
    ----------
    settlement_days : int
        The number of settlement days.
    face_amount : float
        The face amount of the bond.
    growth_only : bool
        Whether the bond has growth-only coupons.
    baseCPI : float
        The base CPI value.
    observation_lag : :class:`~quantlib.time.date.Period`
        The observation lag for the CPI index.
    cpi_index : :class:`~quantlib.indexes.inflation_index.ZeroInflationIndex`
        The CPI index.
    observation_interpolation : :class:`~quantlib.cashflows.cpicoupon.InterpolationType`
        The observation interpolation type.
    schedule : :class:`~quantlib.time.schedule.Schedule`
        The bond's schedule.
    coupons : list of float
        The coupon rates.
    accrual_day_counter : :class:`~quantlib.time.daycounter.DayCounter`
        The accrual day counter.
    payment_convention : :class:`~quantlib.time.businessdayconvention.BusinessDayConvention`, optional
        The payment business day convention.
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
    """
    def __init__(self, Natural settlement_days, Real face_amount, bool growth_only,
                 Real baseCPI, Period observation_lag not None,
                 ZeroInflationIndex cpi_index not None,
                 InterpolationType observation_interpolation,
                 Schedule schedule, vector[Rate] coupons,
                 DayCounter accrual_day_counter,
                 BusinessDayConvention payment_convention=Following,
                 Date issue_date=Date(), Calendar payment_calendar=Calendar(),
                 Period ex_coupon_period=Period(), Calendar ex_coupon_calendar=Calendar(),
                 BusinessDayConvention ex_coupon_convention=Unadjusted,
                 bool ex_coupon_end_of_month=False):

        self._thisptr.reset(
            new _cpibond.CPIBond(
                settlement_days, face_amount, growth_only, baseCPI,
                deref(observation_lag._thisptr),
                static_pointer_cast[_inf.ZeroInflationIndex](
                    cpi_index._thisptr),
                observation_interpolation,
                schedule._thisptr, coupons,
                deref(accrual_day_counter._thisptr), payment_convention,
                issue_date._thisptr,
                payment_calendar._thisptr, deref(ex_coupon_period._thisptr),
                ex_coupon_calendar._thisptr, ex_coupon_convention,
                ex_coupon_end_of_month
            )
        )
