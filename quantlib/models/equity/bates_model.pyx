# Copyright (C) 2011, Enthought Inc
# Copyright (C) 2011, Patrick Henaff
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the license for more details.

include '../../types.pxi'

from cython.operator cimport dereference as deref

from . cimport _bates_model as _bm
from . cimport _heston_model as _hm
cimport quantlib.processes._heston_process as _hp
cimport quantlib._stochastic_process as _sp
from quantlib.handle cimport Handle, shared_ptr, static_pointer_cast
from quantlib.processes.heston_process cimport HestonProcess
from quantlib.processes.bates_process cimport BatesProcess
from .heston_model cimport HestonModel
from .bates_model cimport BatesModel

cdef class BatesModel(HestonModel):

    def __init__(self, BatesProcess process):
        self._thisptr = shared_ptr[_hm.HestonModel](
            new _bm.BatesModel(static_pointer_cast[_hp.BatesProcess](
                process._thisptr)))

    def __str__(self):
        return ('Bates model\n'
                f'v0: {self.v0} kappa: {self.kappa} theta: {self.theta} sigma: {self.sigma}\n'
                f'rho: {self.rho} lambda: {self._lambda()} nu: {self._nu()} delta: {self._delta()}')

    def process(self):
        cdef BatesProcess process = BatesProcess.__new__(BatesProcess)
        process._thisptr = static_pointer_cast[_sp.StochasticProcess](
            self._thisptr.get().process())
        return process

    cdef double _lambda(self) nogil:
        return (<_bm.BatesModel*> self._thisptr.get()).Lambda()

    cdef double _nu(self) nogil:
        return (<_bm.BatesModel *> self._thisptr.get()).nu()

    cdef double _delta(self) nogil:
        return (<_bm.BatesModel *> self._thisptr.get()).delta()

    @property
    def Lambda(self):
        return self._lambda()

    @property
    def nu(self):
        return self._nu()

    @property
    def delta(self):
        return self._delta()

cdef class BatesDetJumpModel(BatesModel):

    def __init__(self, BatesProcess process,
                 Real kappaLambda=1.0, Real thetaLambda=0.1):
        self._thisptr = shared_ptr[_hm.HestonModel](
            new _bm.BatesDetJumpModel(static_pointer_cast[_hp.BatesProcess](
                process._thisptr),
                kappaLambda,
                thetaLambda))

    def __str__(self):
        return ('Bates Det Jump model\n'
                f'v0: {self.v0} kappa: {self.kapp} theta: {self.theta} sigma: {self.sigma}\n'
                f'rho: {self.rho} lambda: {self._lambda()} nu: {self._nu()} delta: {self._delta()}\n'
                f'kappa_lambda: {self._kappaLambda()} theta_lambda: {self._thetaLambda()}'
                )
    cdef double _kappaLambda(self) nogil:
        return (<_bm.BatesDetJumpModel*> self._thisptr.get()).kappaLambda()

    cdef double _thetaLambda(self) nogil:
        return (<_bm.BatesDetJumpModel*> self._thisptr.get()).thetaLambda()

    @property
    def kappaLambda(self):
        return self._kappaLambda()

    @property
    def thetaLambda(self):
        return self._thetaLambda()

cdef class BatesDoubleExpModel(HestonModel):

    def __init__(self, HestonProcess process,
                 Real Lambda=0.1,
                 Real nuUp=0.1, Real nuDown=0.1,
                 Real p=0.5):
        self._thisptr = shared_ptr[_hm.HestonModel](
            new _bm.BatesDoubleExpModel(static_pointer_cast[_hp.HestonProcess](
                process._thisptr), Lambda, nuUp, nuDown, p))

    def __str__(self):
        return ('Bates Double Exp model\n'
                f'v0: {self.v0} kappa: {self.kappa} theta: {self.theta} sigma: {self.sigma}\n'
                f'rho: {self.rho} lambda: {self._lambda()} nuUp: {self._nuUp()} nuDown: {self._nuDown()} p: {self._p()}'
            )

    cdef double _lambda(self) nogil:
        return (<_bm.BatesDoubleExpModel*> self._thisptr.get()).Lambda()

    cdef double _nuUp(self) nogil:
        return (<_bm.BatesDoubleExpModel *> self._thisptr.get()).nuUp()

    cdef double _nuDown(self) nogil:
        return (<_bm.BatesDoubleExpModel *> self._thisptr.get()).nuDown()

    cdef double _p(self) nogil:
        return (<_bm.BatesDoubleExpModel *> self._thisptr.get()).p()

    @property
    def Lambda(self):
        return self._lambda()

    @property
    def nuUp(self):
        return self._nuUp()

    @property
    def nuDown(self):
        return self._nuDown()

    @property
    def p(self):
        return self._p()

cdef class BatesDoubleExpDetJumpModel(BatesDoubleExpModel):

    def __init__(self, HestonProcess process,
                 Real Lambda=0.1,
                 Real nuUp=0.1, Real nuDown=0.1,
                 Real p=0.5, Real kappaLambda=1.0, Real thetaLambda=.1):
        self._thisptr = shared_ptr[_hm.HestonModel](
            new _bm.BatesDoubleExpDetJumpModel(static_pointer_cast[_hp.HestonProcess](
                process._thisptr),
                Lambda, nuUp, nuDown, p, kappaLambda, thetaLambda))

    def __str__(self):
        return ('Bates Double Exp Det Jump model\n'
        f'v0: {self.v0} kappa: {self.kappa} theta: {self.theta} sigma: {self.sigma}\n'
        f'rho: {self.rho} lambda: {self._lambda()} nuUp: {self._nuUp()} nuDown: {self._nuDown()} p: {self._p()}\n'
        f'kappaLambda: {self._kappaLambda()} thetaLambda: {self._thetaLambda()}\n'
        )

    cdef double _kappaLambda(self) nogil:
        return (<_bm.BatesDoubleExpDetJumpModel*> self._thisptr.get()).kappaLambda()

    cdef double _thetaLambda(self) nogil:
        return (<_bm.BatesDoubleExpDetJumpModel*> self._thisptr.get()).thetaLambda()

    @property
    def kappaLambda(self):
        return self._kappaLambda()

    @property
    def thetaLambda(self):
        return self._thetaLambda()
