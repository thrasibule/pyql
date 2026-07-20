cdef extern from 'ql/time/dategenerationrule.hpp' namespace 'QuantLib::DateGeneration':
    cpdef enum class DateGeneration "QuantLib::DateGeneration::Rule":
        """Date-generation rules for building payment schedules.

        These conventions specify the rule used to generate dates in a Schedule.

        ========================  ================================================
        Value                     Description
        ========================  ================================================
        Backward                  Backward from termination date to effective date
        Forward                   Forward from effective date to termination date
        Zero                      No intermediate dates between effective date
                                  and termination date
        ThirdWednesday            All dates but effective date and termination
                                  date are the third Wednesday of their month
                                  (forward calculation)
        ThirdWednesdayInclusive   All dates including effective date and termination
                                  are the third Wednesday of their month
        Twentieth                 All dates but the effective date are the
                                  twentieth of their month (used for CDS
                                  schedules in emerging markets)
        TwentiethIMM              All dates but the effective date are the
                                  twentieth of an IMM month (used for CDS
                                  schedules)
        OldCDS                    Same as TwentiethIMM with unrestricted date
                                  ends and long/short stub coupon period
        CDS                       Credit derivatives standard rule since
                                  'Big Bang' changes in 2009
        CDS2015                   Credit derivatives standard rule since
                                  December 20th, 2015
        ========================  ================================================
        """
        Backward
        Forward
        Zero
        ThirdWednesday
        ThirdWednesdayInclusive
        Twentieth
        TwentiethIMM
        OldCDS
        CDS
        CDS2015
