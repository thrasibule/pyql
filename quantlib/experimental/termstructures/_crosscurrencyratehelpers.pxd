from quantlib.types cimport Integer, Natural
from libcpp cimport bool
from libcpp.optional cimport optional
from quantlib._handle cimport Handle
from quantlib.ext cimport shared_ptr
from quantlib._quote cimport Quote
from quantlib.time.businessdayconvention cimport BusinessDayConvention
from quantlib.time._calendar cimport Calendar
from quantlib.time._date cimport Date
from quantlib.time._period cimport Period, Frequency
from quantlib.indexes._ibor_index cimport IborIndex
from quantlib.termstructures._yield_term_structure cimport YieldTermStructure
from quantlib.termstructures.yields._rate_helpers cimport RelativeDateRateHelper

cdef extern from 'ql/experimental/termstructures/crosscurrencyratehelpers.hpp' namespace 'QuantLib' nogil:
    cdef cppclass ConstNotionalCrossCurrencyBasisSwapRateHelper(RelativeDateRateHelper):
        ConstNotionalCrossCurrencyBasisSwapRateHelper(
            const Handle[Quote]& basis,
            const Period& tenor,
            Natural fixingDays,
            const Calendar& calendar,
            BusinessDayConvention convention,
            bool endOfMonth,
            const shared_ptr[IborIndex]& baseCurrencyIndex,
            const shared_ptr[IborIndex]& quoteCurrencyIndex,
            const Handle[YieldTermStructure]& collateralCurve,
            bool isFxBaseCurrencyCollateralCurrency,
            bool isBasisOnFxBaseCurrencyLeg,
            optional[Frequency] paymentFrequency, # = std::nullopt
            Integer paymentLag, # = 0
            optional[Frequency] quoteCurrencyPaymentFrequency) # = std::nullopt


    cdef cppclass MtMCrossCurrencyBasisSwapRateHelper(RelativeDateRateHelper):
        MtMCrossCurrencyBasisSwapRateHelper(const Handle[Quote]& basis,
                                            const Period& tenor,
                                            Natural fixingDays,
                                            const Calendar& calendar,
                                            BusinessDayConvention convention,
                                            bool endOfMonth,
                                            const shared_ptr[IborIndex]& baseCurrencyIndex,
                                            const shared_ptr[IborIndex]& quoteCurrencyIndex,
                                            const Handle[YieldTermStructure]& collateralCurve,
                                            bool isFxBaseCurrencyCollateralCurrency,
                                            bool isBasisOnFxBaseCurrencyLeg,
                                            bool isFxBaseCurrencyLegResettable,
                                            optional[Frequency] paymentFrequency, # = std::nullopt
                                            Integer paymentLag, # = 0
                                            optional[Frequency] quoteCurrencyPaymentFrequency) # = std::nullopt
