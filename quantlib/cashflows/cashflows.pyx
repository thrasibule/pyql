include '../types.pxi'
from libcpp cimport bool
from cython.operator cimport dereference as deref
from . cimport _cashflows
from quantlib.cashflow cimport Leg
from quantlib.time.daycounter cimport DayCounter
from quantlib.time.date cimport Date
from quantlib.interest_rate cimport InterestRate
from quantlib._compounding cimport Compounding, Continuous
from quantlib.time.frequency cimport Frequency, Annual

def bps(Leg leg, yield_rate, DayCounter day_counter=None,
         Compounding compounding=Continuous,
         bool include_settlement_date_flows=False,
         Frequency frequency=Annual,
         Date settlement_date=Date(), Date npv_date=Date()):
    if isinstance(yield_rate, InterestRate):
        return _cashflows.bps(leg._thisptr,
                              (<InterestRate>yield_rate)._thisptr,
                              include_settlement_date_flows,
                              deref(settlement_date._thisptr),
                              deref(npv_date._thisptr))
    elif isinstance(yield_rate, float) and day_counter is not None:
         return _cashflows.bps(leg._thisptr,
                               <Rate>yield_rate,
                               deref(day_counter._thisptr),
                               compounding,
                               frequency,
                               include_settlement_date_flows,
                               deref(settlement_date._thisptr),
                               deref(npv_date._thisptr))
