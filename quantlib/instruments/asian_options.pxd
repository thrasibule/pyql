from .oneassetoption cimport OneAssetOption

cdef extern from 'ql/instruments/averagetype.hpp' namespace 'QuantLib::Average':
    cpdef enum class AverageType "QuantLib::Average::Type":
        """Asian option average type: Arithmetic or Geometric."""
        Arithmetic
        Geometric

cdef class ContinuousAveragingAsianOption(OneAssetOption):
    pass
