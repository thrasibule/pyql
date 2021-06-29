"""
 Copyright (C) 2011, Enthought Inc
 Copyright (C) 2011, Patrick Henaff

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""

include '../../types.pxi'

from libcpp cimport bool

from quantlib.handle cimport shared_ptr, Handle, RelinkableHandle
from quantlib._quote cimport Quote
from quantlib.time._calendar cimport BusinessDayConvention, Calendar
from quantlib.time._date cimport Date
from quantlib.time._daycounter cimport DayCounter
from quantlib.time._period cimport Period, Frequency
from ._flat_forward cimport YieldTermStructure
from quantlib.indexes._ibor_index cimport IborIndex
from quantlib.indexes._swap_index cimport SwapIndex
from quantlib.instruments._vanillaswap cimport VanillaSwap

from quantlib.termstructures._helpers cimport BootstrapHelper, \
                                              RelativeDateBootstrapHelper
from ..helpers cimport Pillar

cdef extern from 'ql/termstructures/yield/ratehelpers.hpp' namespace 'QuantLib':
    ctypedef BootstrapHelper[YieldTermStructure] RateHelper
    ctypedef RelativeDateBootstrapHelper[YieldTermStructure] RelativeDateRateHelper

    cdef cppclass DepositRateHelper(RateHelper):
        DepositRateHelper(Handle[Quote]& rate,
                          Period& tenor,
                          Natural fixingDays,
                          Calendar& calendar,
                          BusinessDayConvention convention,
                          bool endOfMonth,
                          DayCounter& dayCounter) except +
        DepositRateHelper(Rate rate,
                          Period& tenor,
                          Natural fixingDays,
                          Calendar& calendar,
                          BusinessDayConvention convention,
                          bool endOfMonth,
                          DayCounter& dayCounter) except +

        DepositRateHelper(Handle[Quote]& rate,
                          shared_ptr[IborIndex]& iborIndex) except +
        DepositRateHelper(Rate rate,
                          shared_ptr[IborIndex]& iborIndex) except +

    cdef cppclass FraRateHelper(RelativeDateRateHelper):
        FraRateHelper(Handle[Quote]& rate,
                      Natural monthsToStart,
                      Natural monthsToEnd,
                      Natural fixingDays,
                      Calendar& calendar,
                      BusinessDayConvention convention,
                      bool endOfMonth,
                      DayCounter& dayCounter) except +
        FraRateHelper(Rate rate,
                      Natural monthsToStart,
                      Natural monthsToEnd,
                      Natural fixingDays,
                      Calendar& calendar,
                      BusinessDayConvention convention,
                      bool endOfMonth,
                      DayCounter& dayCounter) except +


    cdef cppclass SwapRateHelper(RelativeDateRateHelper):
        SwapRateHelper(Handle[Quote]& rate,
                       Period& tenor,
                       Calendar& calendar,
                       Frequency& fixedFrequency,
                       BusinessDayConvention fixedConvention,
                       DayCounter& fixedDayCount,
                       shared_ptr[IborIndex]& iborIndex,
                       Handle[Quote]& spread,
                       Period& fwdStart,
                       # exogenous discounting curve
                       Handle[YieldTermStructure]& discountingCurve, #= Handle<YieldTermStructure>()
                       Natural settlement_days, #= Null<Natural>(),
                       Pillar pillar, # = Pillar::LastRelevantDate,
                       Date customPillarDate, # = Date(),
                       bool endOfMonth # = false
        ) except +
        SwapRateHelper(Rate rate,
                       Period& tenor,
                       Calendar& calendar,
                       Frequency& fixedFrequency,
                       BusinessDayConvention fixedConvention,
                       DayCounter& fixedDayCount,
                       shared_ptr[IborIndex]& iborIndex,
                       Handle[Quote]& spread,
                       Period& fwdStart,
                       # exogenous discounting curve
                       Handle[YieldTermStructure]& discountingCurve, #= Handle<YieldTermStructure>()
                       Natural settlement_days, #= Null<Natural>(),
                       Pillar pillar, # = Pillar::LastRelevantDate,
                       Date customPillarDate, # = Date(),
                       bool endOfMonth # = false
        ) except +
        SwapRateHelper(Handle[Quote]& rate,
                       shared_ptr[SwapIndex]& swapIndex,
                       Handle[Quote]& spread, # = Handle<Quote>(),
                       Period& fwdStart, # = 0*Days,
                       # exogenous discounting curve
                       Handle[YieldTermStructure]& discountingCurve, #= Handle<YieldTermStructure>()
                       Pillar pillar, # = Pillar::LastRelevantDate,
                       Date customPillarDate, # = Date(),
                       bool endOfMonth # = false
        ) except +
        SwapRateHelper(Rate rate,
                       shared_ptr[SwapIndex]& swapIndex,
                       Handle[Quote]& spread, # = Handle<Quote>(),
                       Period& fwdStart, # = 0*Days,
                       # exogenous discounting curve
                       Handle[YieldTermStructure]& discountingCurve, #= Handle<YieldTermStructure>()
                       Pillar pillar, # = Pillar::LastRelevantDate,
                       Date customPillarDate, # = Date(),
                       bool endOfMonth # = false
        ) except +
        Spread spread()
        shared_ptr[VanillaSwap] swap()
        Period& forwardStart()

    cdef cppclass FuturesRateHelper(RateHelper):
        FuturesRateHelper(Handle[Quote]& price,
                          Date& immDate,
                          Natural lengthInMonths,
                          Calendar& calendar,
                          BusinessDayConvention convention,
                          bool endOfMonth,
                          DayCounter& dayCounter,
                          Handle[Quote]& convexity_adjustment,
        ) except +
        FuturesRateHelper(Real price,
                          Date& immDate,
                          Natural lengthInMonths,
                          Calendar& calendar,
                          BusinessDayConvention convention,
                          bool endOfMonth,
                          DayCounter& dayCounter,
                          Rate convexity_adjustment,
        ) except +
