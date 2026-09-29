from quantlib.types cimport Integer, Natural
from cython.operator cimport dereference as deref
from libcpp cimport bool
from quantlib.ext cimport static_pointer_cast
from quantlib.cashflows.rateaveraging cimport RateAveraging
from quantlib.time.businessdayconvention cimport BusinessDayConvention
from quantlib.time.date cimport Period
from quantlib.time._period cimport Frequency
from quantlib.time.calendar cimport Calendar
from quantlib.time.dategeneration cimport DateGeneration
from quantlib.indexes.ibor_index cimport OvernightIndex
from quantlib.indexes cimport _ibor_index as _ii
from quantlib.instruments.swap cimport Swap
from quantlib.quote cimport Quote
from quantlib.handle cimport HandleYieldTermStructure
from . cimport _basisswapratehelpers as _bsrh

cdef class OvernightOvernightBasisSwapRateHelper(RelativeDateRateHelper):
    """Rate helper for bootstrapping over overnight-overnight basis swaps

    The swap is assumed to pay `base_index` + basis and receive
    `other_index`. The helper can be used to bootstrap the forecast
    curve for either index; the other index must have an existing
    forecast curve.

    An exogenous discount curve can be passed.  If none is passed, the
    curve being bootstrapped is also used for discounting.

    Both legs share the same schedule and payment lag, but their
    averaging methods can be configured independently, e.g. an
    arithmetically averaged Fed Funds leg against a compounded SOFR leg.
    Telescopic value dates are only applied to compounded legs.

    Passing ``Frequency.NoFrequency`` as the payment frequency creates one
    coupon on each leg spanning the full swap tenor.
    """

    def __init__(self, Quote basis not None, Period tenor not None,
                 Natural settlement_days, Calendar calendar not None,
                 BusinessDayConvention convention, bool end_of_month,
                 OvernightIndex base_index not None,
                 OvernightIndex other_index not None,
                 HandleYieldTermStructure discount_curve not None=HandleYieldTermStructure(),
                 bool bootstrap_base_curve=False,
                 Integer payment_lag=0,
                 Frequency payment_frequency=Frequency.Annual,
                 RateAveraging base_averaging_method=RateAveraging.Compound,
                 RateAveraging other_averaging_method=RateAveraging.Compound,
                 bool telescopic_value_dates=False,
                 DateGeneration rule=DateGeneration.Backward):
        self._thisptr.reset(
            new _bsrh.OvernightOvernightBasisSwapRateHelper(
                basis.handle(),
                deref(tenor._thisptr),
                settlement_days,
                calendar._thisptr,
                convention,
                end_of_month,
                static_pointer_cast[_ii.OvernightIndex](base_index._thisptr),
                static_pointer_cast[_ii.OvernightIndex](other_index._thisptr),
                discount_curve.handle(),
                bootstrap_base_curve,
                payment_lag,
                payment_frequency,
                base_averaging_method,
                other_averaging_method,
                telescopic_value_dates,
                rule
            )
        )

    def swap(self):
        """The underlying basis swap (base leg first, other leg second)."""
        cdef Swap instance = Swap.__new__(Swap)
        instance._thisptr = (<_bsrh.OvernightOvernightBasisSwapRateHelper*>self._thisptr.get()).swap()
        return instance
