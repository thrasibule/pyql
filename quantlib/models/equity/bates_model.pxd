"""
 Copyright (C) 2011, Enthought Inc
 Copyright (C) 2011, Patrick Henaff

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""
cimport quantlib.models.equity._bates_model as _bm

from quantlib.handle cimport shared_ptr
from quantlib.models.equity.heston_model cimport HestonModel

cdef class BatesModel(HestonModel):
    cdef inline double _nu(self) nogil
    cdef inline double _delta(self) nogil
    cdef inline double _lambda(self) nogil

cdef class BatesDetJumpModel(BatesModel):
   cdef inline double _kappaLambda(self) nogil
   cdef inline double _thetaLambda(self) nogil

cdef class BatesDoubleExpModel(HestonModel):
    cdef inline double _p(self) nogil
    cdef inline double _nuDown(self) nogil
    cdef inline double _nuUp(self) nogil
    cdef inline double _lambda(self) nogil

cdef class BatesDoubleExpDetJumpModel(BatesDoubleExpModel):
    cdef inline double _thetaLambda(self) nogil
    cdef inline double _kappaLambda(self) nogil
