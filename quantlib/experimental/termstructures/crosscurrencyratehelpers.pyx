from quantlib.types cimport Integer, Natural
from cython.operator cimport dereference as deref
from libcpp cimport bool
from libcpp.optional cimport optional
from quantlib.time._period cimport Frequency
from quantlib.ext cimport static_pointer_cast
from quantlib.time.businessdayconvention cimport BusinessDayConvention
from quantlib.time.date cimport Period
from quantlib.time.calendar cimport Calendar
from quantlib.indexes.ibor_index cimport IborIndex
from quantlib.indexes cimport _ibor_index as _ii
from quantlib.quote cimport Quote
from quantlib.handle cimport HandleYieldTermStructure
from . cimport _crosscurrencyratehelpers as _ccyrh

cdef class ConstNotionalCrossCurrencyBasisSwapRateHelper(RelativeDateRateHelper):
    """Rate helper for bootstrapping over constant-notional cross-currency basis swaps.

    Unlike marked-to-market cross currency swaps, both notionals expressed in
    base and quote currency remain constant throughout the lifetime of the
    swap [1]_.

    Parameters
    ----------
    basis : Quote
        The basis spread, as a decimal, on the leg given by
        ``is_basis_on_fx_base_currency_leg``.
    tenor : Period
        The swap's maturity, from its start date.
    fixing_days : int
        Business days from the evaluation date to the start date (the spot lag).
    calendar : Calendar
        Calendar used to roll the dates and to pay, on both legs.
    convention : BusinessDayConvention
        Convention used to roll the schedule dates.
    end_of_month : bool
        Whether the schedule dates follow the end of the month.
    base_currency_index : IborIndex
        Floating index of the base-currency leg (EUR in EUR-USD). An overnight
        index needs ``payment_frequency``.
    quote_currency_index : IborIndex
        Floating index of the quote-currency leg (USD in EUR-USD).
    collateral_curve : HandleYieldTermStructure
        Discount curve of the collateral currency.
    is_fx_base_currency_collateral_currency : bool
        True if the collateral is paid in the base currency; the curve
        bootstrapped is then the quote currency's, otherwise the base
        currency's.
    is_basis_on_fx_base_currency_leg : bool
        True if the basis is paid on the base-currency leg.
    payment_frequency : Frequency, optional
        Payment frequency of the base-currency leg. By default the schedule
        comes from the base-currency index tenor; an overnight index (e.g.
        :class:`~quantlib.indexes.ibor.estr.Estr`) has none, so give one: its
        leg then compounds the overnight rate over each period.
    payment_lag : int, optional
        Coupon payment lag in days, on both legs (default 0).
    quote_currency_payment_frequency : Frequency, optional
        Payment frequency of the quote-currency leg; defaults to
        ``payment_frequency``, then to the quote-currency index tenor.

    Notes
    -----
    Consider the currency pair EUR-USD: EUR is the base currency, USD the
    quote currency, the amount of quote currency paid for one unit of base
    currency. A cross currency swap has a base-currency leg and a
    quote-currency leg, and its parameters (collateral currency, basis,
    resetting or constant notional legs) are defined relative to them. For
    EUR-USD basis swaps, for example, the collateral is paid in the quote
    currency (USD) and the basis is given on the base-currency leg (EUR).

    References
    ----------
    .. [1] N. Moreni and A. Pallavicini, "FX Modelling in Collateralized
       Markets: foreign measures, basis curves and pricing formulae", 2015.
    """

    def __init__(self, Quote basis, Period tenor, Natural fixing_days, Calendar calendar,
                 BusinessDayConvention convention, bool end_of_month, IborIndex base_currency_index,
                 IborIndex quote_currency_index, HandleYieldTermStructure collateral_curve,
                 bool is_fx_base_currency_collateral_currency,
                 bool is_basis_on_fx_base_currency_leg,
                 payment_frequency=None,
                 Integer payment_lag=0,
                 quote_currency_payment_frequency=None):
        cdef:
            optional[Frequency] payment_frequency_opt
            optional[Frequency] quote_currency_payment_frequency_opt
        if payment_frequency is not None:
            payment_frequency_opt = <Frequency>payment_frequency
        if quote_currency_payment_frequency is not None:
            quote_currency_payment_frequency_opt = <Frequency>quote_currency_payment_frequency
        self._thisptr.reset(
            new _ccyrh.ConstNotionalCrossCurrencyBasisSwapRateHelper(
                basis.handle(),
                deref(tenor._thisptr),
                fixing_days,
                calendar._thisptr,
                convention,
                end_of_month,
                static_pointer_cast[_ii.IborIndex](base_currency_index._thisptr),
                static_pointer_cast[_ii.IborIndex](quote_currency_index._thisptr),
                collateral_curve.handle(),
                is_fx_base_currency_collateral_currency,
                is_basis_on_fx_base_currency_leg,
                payment_frequency_opt,
                payment_lag,
                quote_currency_payment_frequency_opt,
            )
        )

cdef class MtMCrossCurrencyBasisSwapRateHelper(RelativeDateRateHelper):
     """Rate helper for bootstrapping over mark-to-market cross-currency basis swaps.

     Helper for a cross currency swap with resetting notional: at each
     interest payment the notional of the MtM leg is reset to reflect the
     changes in the FX rate, reducing the counterparty and FX risk of the
     structure [1]_. The conventions on base and quote currencies are those
     of :class:`ConstNotionalCrossCurrencyBasisSwapRateHelper`.

     Parameters
     ----------
     basis : Quote
         The basis spread, as a decimal, on the leg given by
         ``is_basis_on_fx_base_currency_leg``.
     tenor : Period
         The swap's maturity, from its start date.
     fixing_days : int
         Business days from the evaluation date to the start date (the spot lag).
     calendar : Calendar
         Calendar used to roll the dates and to pay, on both legs.
     convention : BusinessDayConvention
         Convention used to roll the schedule dates.
     end_of_month : bool
         Whether the schedule dates follow the end of the month.
     base_currency_index : IborIndex
         Floating index of the base-currency leg (EUR in EUR-USD). An overnight
         index needs ``payment_frequency``.
     quote_currency_index : IborIndex
         Floating index of the quote-currency leg (USD in EUR-USD).
     collateral_curve : HandleYieldTermStructure
         Discount curve of the collateral currency.
     is_fx_base_currency_collateral_currency : bool
         True if the collateral is paid in the base currency; the curve
         bootstrapped is then the quote currency's, otherwise the base
         currency's.
     is_basis_on_fx_base_currency_leg : bool
         True if the basis is paid on the base-currency leg.
     is_fx_base_currency_leg_resettable : bool
         True if the base-currency leg's notional resets with the FX rate at
         each period; otherwise the quote-currency leg's does.
     payment_frequency : Frequency, optional
         Payment frequency of the base-currency leg. By default the schedule
         comes from the base-currency index tenor; an overnight index (e.g.
         :class:`~quantlib.indexes.ibor.estr.Estr`) has none, so give one: its
         leg then compounds the overnight rate over each period.
     payment_lag : int, optional
         Coupon payment lag in days, on both legs (default 0); the notional
         exchanges stay on the effective and maturity dates.
     quote_currency_payment_frequency : Frequency, optional
         Payment frequency of the quote-currency leg; defaults to
         ``payment_frequency``, then to the quote-currency index tenor.

     References
     ----------
     .. [1] N. Moreni and A. Pallavicini, "FX Modelling in Collateralized
        Markets: foreign measures, basis curves and pricing formulae", 2015.
     """

     def __init__(self, Quote basis, Period tenor, Natural fixing_days, Calendar calendar,
                  BusinessDayConvention convention, bool end_of_month, IborIndex base_currency_index,
                  IborIndex quote_currency_index, HandleYieldTermStructure collateral_curve,
                  bool is_fx_base_currency_collateral_currency,
                  bool is_basis_on_fx_base_currency_leg,
                  bool is_fx_base_currency_leg_resettable,
                  payment_frequency=None,
                  Integer payment_lag=0,
                  quote_currency_payment_frequency=None):
         cdef:
             optional[Frequency] payment_frequency_opt
             optional[Frequency] quote_currency_payment_frequency_opt
         if payment_frequency is not None:
             payment_frequency_opt = <Frequency>payment_frequency
         if quote_currency_payment_frequency is not None:
             quote_currency_payment_frequency_opt = <Frequency>quote_currency_payment_frequency
         self._thisptr.reset(
             new _ccyrh.MtMCrossCurrencyBasisSwapRateHelper(
                 basis.handle(),
                 deref(tenor._thisptr),
                 fixing_days,
                 calendar._thisptr,
                 convention,
                 end_of_month,
                 static_pointer_cast[_ii.IborIndex](base_currency_index._thisptr),
                 static_pointer_cast[_ii.IborIndex](quote_currency_index._thisptr),
                 collateral_curve.handle(),
                 is_fx_base_currency_collateral_currency,
                 is_basis_on_fx_base_currency_leg,
                 is_fx_base_currency_leg_resettable,
                 payment_frequency_opt,
                 payment_lag,
                 quote_currency_payment_frequency_opt,
             )
         )
