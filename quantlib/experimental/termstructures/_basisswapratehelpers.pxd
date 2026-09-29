from quantlib.types cimport Integer, Natural
from libcpp cimport bool
from quantlib._handle cimport Handle
from quantlib.ext cimport shared_ptr
from quantlib._quote cimport Quote
from quantlib.cashflows.rateaveraging cimport RateAveraging
from quantlib.time.businessdayconvention cimport BusinessDayConvention
from quantlib.time._calendar cimport Calendar
from quantlib.time._period cimport Period, Frequency
from quantlib.time.dategeneration cimport DateGeneration
from quantlib.indexes._ibor_index cimport OvernightIndex
from quantlib.instruments._swap cimport Swap
from quantlib.termstructures._yield_term_structure cimport YieldTermStructure
from quantlib.termstructures.yields._rate_helpers cimport RelativeDateRateHelper

cdef extern from 'ql/experimental/termstructures/basisswapratehelpers.hpp' namespace 'QuantLib' nogil:
    cdef cppclass OvernightOvernightBasisSwapRateHelper(RelativeDateRateHelper):
        OvernightOvernightBasisSwapRateHelper(
            const Handle[Quote]& basis,
            const Period& tenor,
            Natural settlementDays,
            Calendar calendar,
            BusinessDayConvention convention,
            bool endOfMonth,
            const shared_ptr[OvernightIndex]& baseIndex,
            const shared_ptr[OvernightIndex]& otherIndex,
            Handle[YieldTermStructure] discountHandle,
            bool bootstrapBaseCurve,
            Integer paymentLag,
            Frequency paymentFrequency,
            RateAveraging baseAveragingMethod,
            RateAveraging otherAveragingMethod,
            bool telescopicValueDates,
            DateGeneration rule) except +
        shared_ptr[Swap] swap()
