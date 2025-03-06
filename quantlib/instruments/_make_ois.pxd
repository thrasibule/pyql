from quantlib.types cimport Natural, Real, Rate, Spread
from quantlib.handle cimport shared_ptr, Handle
from libcpp cimport bool
from quantlib.time.businessdayconvention cimport BusinessDayConvention
from quantlib.time._schedule cimport DateGeneration
from quantlib.time._date cimport Date
from quantlib.time._period cimport Period, Frequency
from quantlib.time._daycounter cimport DayCounter
from quantlib.time._calendar cimport Calendar
from quantlib.pricingengines._pricing_engine cimport PricingEngine
from quantlib.termstructures._yield_term_structure cimport YieldTermStructure
from quantlib.indexes._ibor_index cimport OvernightIndex
from quantlib.cashflows.rateaveraging cimport RateAveraging
from ._overnightindexedswap cimport OvernightIndexedSwap

cdef extern from 'ql/instruments/makeois.hpp' namespace 'QuantLib':
    cdef cppclass MakeOIS:
        MakeOIS(const Period& swapTenor,
                const shared_ptr[OvernightIndex]& overnightIndex,
                Rate fixedRate, #= Null<Rate>(),
                const Period& fwdStart) # = 0*Days)

        OvernightIndexedSwap operator()
        shared_ptr[OvernightIndexedSwap] operator()

        MakeOIS& receiveFixed(bool flag) # = true)
        MakeOIS& withType(OvernightIndexedSwap.Type type)
        MakeOIS& withNominal(Real n)

        MakeOIS& withSettlementDays(Natural settlementDays)
        MakeOIS& withEffectiveDate(const Date&)
        MakeOIS& withTerminationDate(const Date&)
        MakeOIS& withRule(DateGeneration r)
        MakeOIS& withFixedLegRule(DateGeneration r)
        MakeOIS& withOvernightLegRule(DateGeneration r)

        MakeOIS& withPaymentFrequency(Frequency f)
        MakeOIS& withFixedLegPaymentFrequency(Frequency f)
        MakeOIS& withOvernightLegPaymentFrequency(Frequency f)
        MakeOIS& withPaymentAdjustment(BusinessDayConvention convention)
        MakeOIS& withPaymentLag(Natural lag)
        MakeOIS& withPaymentCalendar(const Calendar& cal)
        MakeOIS& withCalendar(const Calendar& cal)
        MakeOIS& withFixedLegCalendar(const Calendar& cal)
        MakeOIS& withOvernightLegCalendar(const Calendar& cal)

        MakeOIS& withConvention(BusinessDayConvention bdc)
        MakeOIS& withFixedLegConvention(BusinessDayConvention bdc)
        MakeOIS& withOvernightLegConvention(BusinessDayConvention bdc)
        MakeOIS& withTerminationDateConvention(BusinessDayConvention bdc)
        MakeOIS& withFixedLegTerminationDateConvention(BusinessDayConvention bdc)
        MakeOIS& withOvernightLegTerminationDateConvention(BusinessDayConvention bdc)
        MakeOIS& withEndOfMonth(bool flag) # = true);
        MakeOIS& withFixedLegEndOfMonth(bool flag) # = true);
        MakeOIS& withOvernightLegEndOfMonth(bool flag) # = true);


        MakeOIS& withFixedLegDayCount(const DayCounter& dc)

        MakeOIS& withOvernightLegSpread(Spread sp)

        MakeOIS& withDiscountingTermStructure(
                  const Handle[YieldTermStructure]& discountingTermStructure)

        MakeOIS &withTelescopicValueDates(bool telescopicValueDates)

        MakeOIS& withAveragingMethod(RateAveraging averagingMethod)
        MakeOIS& withLookbackDays(Natural lookbackDays)
        MakeOIS& withLockoutDays(Natural lockoutDays)
        MakeOIS& withObservationShift(bool ObservationShift)

        MakeOIS& withPricingEngine(shared_ptr[PricingEngine]& engine)
