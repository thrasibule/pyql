from quantlib.index cimport Index

cdef extern from "ql/indexes/inflationindex.hpp" namespace "QuantLib::CPI" nogil:
    cpdef enum InterpolationType "QuantLib::CPI::InterpolationType":
        """CPI interpolation type: Flat (no interpolation) or Linear."""
        Flat
        Linear

cdef class InflationIndex(Index):
    pass

cdef class ZeroInflationIndex(InflationIndex):
    pass

cdef class YoYInflationIndex(ZeroInflationIndex):
    pass
