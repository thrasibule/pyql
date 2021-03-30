"""
 Copyright (C) 2011, Enthought Inc
 Copyright (C) 2011, Patrick Henaff

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""

from . cimport _heston_model as _hm

from quantlib.handle cimport shared_ptr, static_pointer_cast
from quantlib.models.calibration_helper cimport BlackCalibrationHelper
from quantlib.models.model cimport CalibratedModel
cimport quantlib.models._model as _mo

cdef class HestonModelHelper(BlackCalibrationHelper):
    pass

cdef class HestonModel(CalibratedModel):

    cdef inline _hm.HestonModel* as_ptr(self) nogil

    cdef inline shared_ptr[_hm.HestonModel] as_shared_ptr(self):
        return static_pointer_cast[_hm.HestonModel](self._thisptr)
