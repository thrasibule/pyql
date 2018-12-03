include '../../types.pxi'

from quantlib.handle cimport shared_ptr
from quantlib.models.equity._heston_model cimport HestonModel
cimport quantlib.processes._heston_process as _hp

cdef extern from 'ql/models/equity/batesmodel.hpp' namespace 'QuantLib' nogil:

    cdef cppclass BatesModel(HestonModel):
        BatesModel(shared_ptr[_hp.BatesProcess]& process)

        Real Lambda 'lambda'() # lambda is a python keyword
        Real nu()
        Real delta()

    cdef cppclass BatesDetJumpModel(BatesModel):
        BatesDetJumpModel()
        BatesDetJumpModel(shared_ptr[_hp.BatesProcess]& process,
                   Real kappaLambda,
                   Real thetaLambda,
        )

        Real kappaLambda()
        Real thetaLambda()

    cdef cppclass BatesDoubleExpModel(HestonModel):
        BatesDoubleExpModel(shared_ptr[_hp.HestonProcess] & process,
                   Real Lambda,
                   Real nuUp,
                   Real nuDown,
                   Real p)

        Real p()
        Real nuDown()
        Real nuUp()
        Real Lambda 'lambda'()

    cdef cppclass BatesDoubleExpDetJumpModel(BatesDoubleExpModel):
        BatesDoubleExpDetJumpModel(shared_ptr[_hp.HestonProcess]& process,
            Real Lambda,
            Real nuUp,
            Real nuDown,
            Real p,
            Real kappaLambda,
            Real thetaLambda)

        Real kappaLambda()
        Real thetaLambda()
