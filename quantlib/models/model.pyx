"""
 Copyright (C) 2015, Enthought Inc
 Copyright (C) 2015, Patrick Henaff

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""

include '../types.pxi'

cimport _model as _mo
from quantlib.handle cimport shared_ptr
from cython.operator cimport dereference as deref
from quantlib.math.array cimport Array
cimport quantlib.math._array as _arr

cdef class CalibratedModel:

    def __cinit__(self):
        pass

    def __init__(self):
        raise ValueError('Cannot instantiate a CalibratedModel')

    def params(self):
        cdef Array x = Array.__new__(Array)
        x._thisptr = shared_ptr[_arr.Array](new _arr.Array(self._thisptr.get().params()))
        return x
    
    def set_params(self, Array params):
        self._thisptr.get().setParams(deref(params._thisptr))
