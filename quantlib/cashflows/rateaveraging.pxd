cdef extern from 'ql/cashflows/rateaveraging.hpp' namespace 'QuantLib::RateAveraging':
    cpdef enum RateAveraging "QuantLib::RateAveraging::Type":
            """Rate averaging method: Simple or Compound."""
            Simple
            Compound
