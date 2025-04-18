include '../types.pxi'
from libcpp cimport bool
from cython.operator cimport dereference as deref
from quantlib.utilities.null cimport Null
from quantlib.handle cimport shared_ptr, static_pointer_cast
from quantlib.cashflows.coupon_pricer cimport FloatingRateCouponPricer
from quantlib.indexes.ibor_index cimport IborIndex
from quantlib.indexes.swap_index cimport SwapIndex
from quantlib.time.date cimport Date, Period
from quantlib.time.daycounter cimport DayCounter

from .._cashflow cimport CashFlow
from . cimport _floating_rate_coupon as _frc
cimport quantlib.indexes._ibor_index as _ii
cimport quantlib.indexes._swap_index as _si

cdef class CappedFlooredCoupon(FloatingRateCoupon):
    def __init__(self, FloatingRateCoupon underlying not None,
                 Rate cap=Null[Real](),
                 Rate floor=Null[Real]()):
        self._thisptr = shared_ptr[CashFlow](new _cfc.CappedFlooredCoupon(
            static_pointer_cast[_frc.FloatingRateCoupon](underlying._thisptr),
            cap,
            floor))

    cdef inline _cfc.CappedFlooredCoupon* as_ptr(self):
        return <_cfc.CappedFlooredCoupon*>self._thisptr.get()

    @property
    def cap(self):
        cdef Real temp = self.as_ptr().cap()
        if temp != Null[Real]():
            return temp

    @property
    def floor(self):
        cdef Real temp = self.as_ptr().floor()
        if temp != Null[Real]():
            return temp

    @property
    def effective_cap(self):
        cdef Real temp = self.as_ptr().effectiveCap()
        if temp != Null[Real]():
            return temp

    @property
    def effective_floor(self):
        cdef Real temp = self.as_ptr().effectiveFloor()
        if temp != Null[Real]():
            return temp

    @property
    def is_capped(self):
        return self.as_ptr().isCapped()

    @property
    def is_floored(self):
        return (<_cfc.CappedFlooredCoupon*>self._thisptr.get()).isFloored()

    @property
    def underlying(self):
        cdef FloatingRateCoupon instance = FloatingRateCoupon.__new__(FloatingRateCoupon)
        instance._thisptr = static_pointer_cast[CashFlow](
            (<_cfc.CappedFlooredCoupon*>self._thisptr.get()).underlying())
        return instance

cdef class CappedFlooredIborCoupon(CappedFlooredCoupon):
    def __init__(self, Date payment_date not None,
                 Real nominal,
                 Date start_date not None,
                 Date end_date not None,
                 Natural fixing_days,
                 IborIndex index not None,
                 Real gearing=1.,
                 Spread spread=0.,
                 Rate cap=Null[Real](),
                 Rate floor=Null[Real](),
                 Date ref_period_start=Date(),
                 Date ref_period_end=Date(),
                 DayCounter day_counter=DayCounter(),
                 bool is_in_arrears=False):
        self._thisptr = shared_ptr[CashFlow](new _cfc.CappedFlooredIborCoupon(
                payment_date._thisptr,
                nominal,
                start_date._thisptr,
                end_date._thisptr,
                fixing_days,
                static_pointer_cast[_ii.IborIndex](index._thisptr),
                gearing,
                spread,
                cap,
                floor,
                ref_period_start._thisptr,
                ref_period_end._thisptr,
                deref(day_counter._thisptr),
                is_in_arrears))

cdef class CappedFlooredCmsCoupon(CappedFlooredCoupon):
    def __init__(self, Date payment_date not None,
                 Real nominal,
                 Date start_date not None,
                 Date end_date not None,
                 Natural fixing_days,
                 SwapIndex index not None,
                 Real gearing=1.,
                 Spread spread=0.,
                 Rate cap=Null[Real](),
                 Rate floor=Null[Real](),
                 Date ref_period_start=Date(),
                 Date ref_period_end=Date(),
                 DayCounter day_counter=DayCounter(),
                 bool is_in_arrears=False):
        self._thisptr = shared_ptr[CashFlow](new _cfc.CappedFlooredCmsCoupon(
                payment_date._thisptr,
                nominal,
                start_date._thisptr,
                end_date._thisptr,
                fixing_days,
                static_pointer_cast[_si.SwapIndex](index._thisptr),
                gearing,
                spread,
                cap,
                floor,
                ref_period_start._thisptr,
                ref_period_end._thisptr,
                deref(day_counter._thisptr),
                is_in_arrears))
