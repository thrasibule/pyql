"""
 Copyright (C) 2015, Enthought Inc
 Copyright (C) 2015, Patrick Henaff

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""

from quantlib.types cimport Real
from libcpp.vector cimport vector
from libcpp cimport bool

from . cimport _calibration_helper as _ch
from .calibration_helper cimport BlackCalibrationHelper
from quantlib.handle cimport shared_ptr
from cython.operator cimport dereference as deref
from quantlib.math.array cimport Array
cimport quantlib.math._array as _arr
from quantlib.math.optimization cimport (Constraint,OptimizationMethod,
                                         EndCriteria)

cdef class CalibratedModel:

    def __init__(self):
        raise ValueError('Cannot instantiate a CalibratedModel')

    def params(self):
        cdef Array instance =  Array.__new__(Array)
        instance._thisptr = self._thisptr.get().params()
        return instance

    def set_params(self, Array params):
        self._thisptr.get().setParams(params._thisptr)

    def calibrate(self, list helpers, OptimizationMethod method, EndCriteria
                  end_criteria, Constraint constraint=Constraint(),
                  vector[Real] weights=[], vector[bool] fix_parameters=[]):

        #convert list to vector
        cdef vector[shared_ptr[_ch.CalibrationHelper]] helpers_vector

        for helper in helpers:
            helpers_vector.push_back((<BlackCalibrationHelper>helper)._thisptr)

        self._thisptr.get().calibrate(
            helpers_vector,
            deref(method._thisptr),
            deref(end_criteria._thisptr),
            deref(constraint._thisptr),
            weights,
            fix_parameters)
