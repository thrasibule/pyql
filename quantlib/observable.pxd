from ._observable cimport PyObserver, Observable as QlObservable
from .handle cimport shared_ptr
from quantlib._instrument cimport Instrument

cdef class Observable:
    cdef shared_ptr[QlObservable] as_observable(self)

cdef class Observer:
    cdef PyObserver _thisptr
