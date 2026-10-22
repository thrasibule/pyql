from quantlib.types cimport Integer, Natural, Rate, Real, Spread

from libcpp cimport bool
from libcpp.optional cimport optional
from libcpp.vector cimport vector
from quantlib.ext cimport shared_ptr
from quantlib.time._date cimport Date
from quantlib.time._daycounter cimport DayCounter
from quantlib._cashflow cimport CashFlow
from quantlib._interest_rate cimport InterestRate
from quantlib.cashflows._floating_rate_coupon cimport FloatingRateCoupon
from quantlib.indexes._ibor_index cimport IborIndex
from quantlib.time._schedule cimport Schedule
from quantlib.time._calendar cimport Calendar
from quantlib.time.businessdayconvention cimport BusinessDayConvention
from quantlib._cashflow cimport Leg

cdef extern from 'ql/cashflows/iborcoupon.hpp' namespace 'QuantLib' nogil:
    cdef cppclass IborCoupon(FloatingRateCoupon):
        IborCoupon(const Date& paymentDate,
                   Real nominal,
                   const Date& startDate,
                   const Date& endDate,
                   Natural fixingDays,
                   const shared_ptr[IborIndex]& index,
                   Real gearing, #= 1.0,
                   Spread spread, #= 0.0,
                   const Date& refPeriodStart, #= Date(),
                   const Date& refPeriodEnd, #= Date(),
                   const DayCounter& dayCounter, #= DayCounter(),
                   bool isInArrears) #=false

        const shared_ptr[IborIndex]& ibor_index()
        const Date fixing_end_date()
        Rate index_fixing()

cdef extern from "ql/cashflows/iborcoupon.hpp" namespace "QuantLib::IborCoupon":
    cdef cppclass Settings:
        @staticmethod
        Settings& instance()
        void createAtParCoupons()

        # When called, IborCoupons are created as par coupons instead of indexed coupons.
        void createIndexedCoupons()

        # If true the IborCoupons are created as par coupons and vice versa.
        # The default depends on the compiler flag QL_USE_INDEXED_COUPON and can be overwritten by
        #    createAtParCoupons() and createIndexedCoupons() */
        bool usingAtParCoupons() const

cdef extern from 'ql/cashflows/iborcoupon.hpp' namespace 'QuantLib' nogil:
    cdef cppclass IborLeg:
        IborLeg(Schedule schedule, shared_ptr[IborIndex] index)
        IborLeg& withNotionals(Real notional)
        IborLeg& withNotionals(const vector[Real]& notionals)
        IborLeg& withPaymentDayCounter(const DayCounter&)
        IborLeg& withPaymentAdjustment(BusinessDayConvention)
        IborLeg& withPaymentLag(Integer lag)
        IborLeg& withPaymentCalendar(const Calendar&)
        IborLeg& withFixingDays(Natural fixingDays)
        IborLeg& withGearings(Real gearing)
        IborLeg& withSpreads(Spread spread)
        IborLeg& withSpreads(const vector[Spread]& spreads)
        IborLeg& withCaps(Rate cap)
        IborLeg& withCaps(const vector[Rate]& caps)
        IborLeg& withFloors(Rate floor)
        IborLeg& withFloors(const vector[Rate]& floors)
        IborLeg& inArrears(bool flag)
        IborLeg& withZeroPayments(bool flag)
        IborLeg& withIndexedCoupons(optional[bool] b)
        IborLeg& withAtParCoupons(bool b)

cdef extern from 'ql/cashflows/iborcoupon.hpp':
    # this allows to declare the cast operator as raising exceptions
    """
    #define ibor_to_leg(x) static_cast<QuantLib::Leg>(x)
    """
    cdef Leg ibor_to_leg(IborLeg) except +
