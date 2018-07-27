include '../types.pxi'
from libcpp cimport bool
from .._cashflow cimport Leg
from quantlib.time._date cimport Date
from quantlib.time._daycounter cimport DayCounter
from quantlib.time.frequency cimport Frequency
from quantlib._compounding cimport Compounding
from quantlib._interest_rate cimport InterestRate

cdef extern from "ql/cashflows/cashflows.hpp" namespace 'QuantLib::CashFlows' nogil:
    cdef Real bps(const Leg& leg,
                  const InterestRate&,
                  bool includeSettlementDateFlows,
                  Date settlementDate, # = Date(),
                  Date npvDate) # = Date())
    cdef Real bps(const Leg& leg,
                  Rate,
                  const DayCounter& dayCounter,
                  Compounding compounding,
                  Frequency frequency,
                  bool includeSettlementDateFlows,
                  Date settlementDate, # = Date(),
                  Date npvDate) # = Date())
