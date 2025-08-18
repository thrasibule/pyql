from . cimport _rate_helpers as _rh
from quantlib.ext cimport shared_ptr

cdef class RateHelper:
    cdef shared_ptr[_rh.RateHelper] _thisptr

cdef class RelativeDateRateHelper(RateHelper):
    pass
