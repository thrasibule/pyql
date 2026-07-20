# cython: c_string_type=unicode, c_string_encoding=ascii
"""
 Copyright (C) 2011, Enthought Inc
 Copyright (C) 2011, Patrick Henaff

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""

include '../types.pxi'
from cython.operator cimport dereference as deref
from libcpp cimport bool
from libcpp.string cimport string

from quantlib.cashflows.rateaveraging cimport RateAveraging
from quantlib.indexes.interest_rate_index cimport InterestRateIndex
from quantlib.instruments.vanillaswap cimport VanillaSwap
from quantlib.instruments.overnightindexedswap cimport OvernightIndexedSwap
from quantlib.indexes.ibor_index cimport IborIndex, OvernightIndex
from quantlib.ext cimport shared_ptr, static_pointer_cast
from quantlib.time.date cimport Period
from quantlib.time.daycounter cimport DayCounter
from quantlib.currency.currency cimport Currency
from quantlib.time.date cimport Date
from quantlib.time.calendar cimport Calendar
from quantlib.time._calendar cimport BusinessDayConvention
from quantlib.handle cimport  Handle, HandleYieldTermStructure
cimport quantlib.termstructures._yield_term_structure as _yts

cimport quantlib._index as _in
cimport quantlib._instrument as _instrument
from . cimport _swap_index as _si
from . cimport _ibor_index as _ii

cdef class SwapIndex(InterestRateIndex):
    """Base class for swap-rate indexes.

    A SwapIndex represents an interest rate swap index (such as the
    ISDA fixing or the CMS rate) used for bootstrapping yield curves
    and pricing swap-related derivatives.

    Parameters
    ----------
    family_name : str
        The family name of the index (e.g., ``"EuriborSwapIsdaFix"``).
    tenor : :class:`~quantlib.time.date.Period`
        The swap tenor (e.g., 5Y, 10Y).
    settlement_days : int
        Number of settlement days.
    currency : :class:`~quantlib.currency.currency.Currency`
        The currency of the swap.
    calendar : :class:`~quantlib.time.calendar.Calendar`
        The fixing calendar.
    fixed_leg_tenor : :class:`~quantlib.time.date.Period`
        The tenor of the fixed leg (e.g., 6M or 1Y).
    fixed_leg_convention : int
        The business day convention for the fixed leg.
    fixed_leg_daycounter : :class:`~quantlib.time.daycounter.DayCounter`
        The day counter for the fixed leg.
    ibor_index : :class:`~quantlib.indexes.ibor_index.IborIndex`
        The Ibor index used for the floating leg.
    discounting_term_structure : :class:`~quantlib.handle.HandleYieldTermStructure`, optional
        An optional discounting curve (for dual-curve bootstrapping).
    """

    def __str__(self):
        return 'Swap index %s' % self.name

    def __init__(self, string family_name, Period tenor not None, Natural settlement_days,
                 Currency currency, Calendar calendar not None,
                 Period fixed_leg_tenor not None,
                 int fixed_leg_convention, DayCounter fixed_leg_daycounter not None,
                 IborIndex ibor_index not None,
                 HandleYieldTermStructure discounting_term_structure=None):

        if discounting_term_structure is None:
            self._thisptr.reset(
                new _si.SwapIndex(
                    family_name,
                    deref(tenor._thisptr),
                    settlement_days,
                    deref(currency._thisptr),
                    calendar._thisptr,
                    deref(fixed_leg_tenor._thisptr),
                    <BusinessDayConvention> fixed_leg_convention,
                    deref(fixed_leg_daycounter._thisptr),
                    static_pointer_cast[_ii.IborIndex](ibor_index._thisptr)
                )
            )
        else:
            self._thisptr.reset(
                new _si.SwapIndex(
                    family_name,
                    deref(tenor._thisptr),
                    settlement_days,
                    deref(currency._thisptr),
                    calendar._thisptr,
                    deref(fixed_leg_tenor._thisptr),
                    <BusinessDayConvention> fixed_leg_convention,
                    deref(fixed_leg_daycounter._thisptr),
                    static_pointer_cast[_ii.IborIndex](ibor_index._thisptr),
                    discounting_term_structure.handle()
                )
            )

    def underlying_swap(self, Date fixing_date not None):
        """Returns the underlying vanilla swap for a given fixing date.

        Parameters
        ----------
        fixing_date : :class:`~quantlib.time.date.Date`
            The fixing date.

        Returns
        -------
        :class:`~quantlib.instruments.vanillaswap.VanillaSwap`
        """
        cdef _si.SwapIndex* swap_index = <_si.SwapIndex*>self._thisptr.get()
        cdef VanillaSwap swap = VanillaSwap.__new__(VanillaSwap)
        swap._thisptr = static_pointer_cast[_instrument.Instrument](
            swap_index.underlyingSwap(fixing_date._thisptr))
        return swap

    @property
    def ibor_index(self):
        """Returns the Ibor index used for the floating leg.

        Returns
        -------
        :class:`~quantlib.indexes.ibor_index.IborIndex`
        """
        cdef _si.SwapIndex* swap_index = <_si.SwapIndex*>self._thisptr.get()
        cdef IborIndex ibor_index = IborIndex.__new__(IborIndex)
        ibor_index._thisptr = static_pointer_cast[_in.Index](swap_index.iborIndex())
        return ibor_index

    @property
    def forwarding_term_structure(self):
        """Returns the forwarding term structure.

        Returns
        -------
        :class:`~quantlib.handle.HandleYieldTermStructure`
        """
        cdef HandleYieldTermStructure h = HandleYieldTermStructure.__new__(HandleYieldTermStructure)
        cdef _si.SwapIndex* swap_index = <_si.SwapIndex*>self._thisptr.get()
        h._handle = new Handle[_yts.YieldTermStructure](
            swap_index.forwardingTermStructure()
            )
        return h

    @property
    def discounting_term_structure(self):
        """Returns the discounting term structure.

        Returns
        -------
        :class:`~quantlib.handle.HandleYieldTermStructure`
        """
        cdef HandleYieldTermStructure h = HandleYieldTermStructure.__new__(HandleYieldTermStructure)
        cdef _si.SwapIndex* swap_index = <_si.SwapIndex*>self._thisptr.get()
        h._handle = new Handle[_yts.YieldTermStructure](
            swap_index.discountingTermStructure()
        )
        return h


cdef class OvernightIndexedSwapIndex(SwapIndex):
    def __init__(self, string family_name, Period tenor not None, Natural settlement_days,
                 Currency currency, OvernightIndex overnight_index not None,
                 bool telescopic_value_dates=False,
                 RateAveraging averaging_method=RateAveraging.Compound):
        self._thisptr.reset(
            new _si.OvernightIndexedSwapIndex(
                family_name,
                deref(tenor._thisptr),
                settlement_days,
                deref(currency._thisptr),
                static_pointer_cast[_ii.OvernightIndex](overnight_index._thisptr),
                telescopic_value_dates,
                averaging_method,
            )
        )

    def underlying_swap(self, Date fixing_date not None):
        cdef _si.OvernightIndexedSwapIndex* swap_index = <_si.OvernightIndexedSwapIndex*>self._thisptr.get()
        cdef OvernightIndexedSwap swap = OvernightIndexedSwap.__new__(OvernightIndexedSwap)
        swap._thisptr = static_pointer_cast[_instrument.Instrument](
            <shared_ptr[_si.OvernightIndexedSwap]>swap_index.underlyingSwap(fixing_date._thisptr))
        return swap
