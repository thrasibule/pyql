from . cimport _optimization as _opt

from quantlib.ext cimport shared_ptr

cdef class OptimizationMethod:

    cdef shared_ptr[_opt.OptimizationMethod] _thisptr

cdef class EndCriteria:

    cdef shared_ptr[_opt.EndCriteria] _thisptr

cdef class Constraint:

    cdef shared_ptr[_opt.Constraint] _thisptr
