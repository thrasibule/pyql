cdef extern from 'ql/termstructures/bootstraphelper.hpp' namespace 'QuantLib::Pillar':
    cpdef enum Pillar "QuantLib::Pillar::Choice":
            """Pillar choice for rate helpers.

            Determines which date is used as the pillar date:

            - **MaturityDate**:     The maturity date of the instrument
            - **LastRelevantDate**: The last relevant date (e.g., last fixing)
            - **CustomDate**:       A user-specified custom date
            """
            MaturityDate
            LastRelevantDate
            CustomDate
