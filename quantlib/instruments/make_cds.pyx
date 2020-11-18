from quantlib.types cimport Natural, Real

from cython.operator cimport dereference as deref
from quantlib.handle cimport static_pointer_cast, shared_ptr
from quantlib.time.date cimport Date, Period
from quantlib.time._schedule cimport Rule
from . cimport _credit_default_swap as _cds
from . cimport _instrument as _in
from .credit_default_swap cimport CreditDefaultSwap

cdef class MakeCreditDefaultSwap:
    def __init__(self, Real coupon_rate, Period tenor=None, Date term_date=None):
        if tenor is None and term_date is None:
            raise ValueError("must specify one of tenor, term_date")
        elif tenor is None:
            self._thisptr = new _make_cds.MakeCreditDefaultSwap(
                deref(term_date._thisptr),
                coupon_rate)
        else:
            self._thisptr = new _make_cds.MakeCreditDefaultSwap(
                deref(tenor._thisptr),
                coupon_rate)

    def __dealloc__(self):
        if self._thisptr is not NULL:
            del self._thisptr
            self._thisptr = NULL

    def __call__(self):
        cdef CreditDefaultSwap instance = CreditDefaultSwap.__new__(CreditDefaultSwap)
        instance._thisptr = static_pointer_cast[_in.Instrument](
            <shared_ptr[_cds.CreditDefaultSwap]>deref(self._thisptr)
        )

    def with_upfront_rate(self, Real upf):
        self._thisptr.withUpfrontRate(upf)
        return self

    def with_side(self, _cds.Side side):
        self._thisptr.withSide(side)
        return self

    def with_date_generation_rule(self, Rule rule):
        self._thisptr.withDateGenerationRule(rule)
        return self

    def with_cash_settlement_days(self, Natural days):
        self._thisptr.withCashSettlementDays(days)
        return self

    def with_nominal(self, Real n):
        self._thisptr.withNominal(n)
        return self
