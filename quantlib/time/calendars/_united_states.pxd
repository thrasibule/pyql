from quantlib.time._calendar cimport Calendar

cdef extern from 'ql/time/calendars/unitedstates.hpp' namespace 'QuantLib':
    cdef cppclass UnitedStates(Calendar):
        enum Market:
            Settlement
            NYSE
            GovernmentBond
            NERC
            LiborImpact
            FederalReserve
        UnitedStates(Market mkt)
