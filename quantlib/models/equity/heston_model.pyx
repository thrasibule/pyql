"""
 Copyright (C) 2011, Enthought Inc
 Copyright (C) 2011, Patrick Henaff

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""

from cython.operator cimport dereference as deref
from quantlib.types cimport Real

from . cimport _heston_model as _hm
cimport quantlib.models._calibration_helper as _ch
cimport quantlib.processes._heston_process as _hp
cimport quantlib._stochastic_process as _sp
cimport quantlib.termstructures.yields._flat_forward as _ffwd
cimport quantlib._quote as _qt
cimport quantlib.pricingengines._pricing_engine as _pe

from quantlib.handle cimport Handle, shared_ptr, static_pointer_cast

from quantlib.processes.heston_process cimport HestonProcess
from quantlib.pricingengines.engine cimport PricingEngine
from quantlib.quotes cimport Quote
from quantlib.time.calendar cimport Calendar
from quantlib.time.date cimport Period
from quantlib.termstructures.yields.flat_forward cimport (
    YieldTermStructure
)
from quantlib.models.calibration_helper cimport BlackCalibrationHelper, CalibrationErrorType


cdef class HestonModelHelper(BlackCalibrationHelper):

    def __str__(self):
        return 'Heston model helper'

    def __init__(self,
        Period maturity,
        Calendar calendar,
        Real s0,
        Real strike_price,
        Quote volatility,
        YieldTermStructure risk_free_rate,
        YieldTermStructure dividend_yield,
        CalibrationErrorType error_type=_ch.RelativePriceError
    ):
        # create handles
        cdef Handle[_qt.Quote] volatility_handle = \
                Handle[_qt.Quote](volatility._thisptr)

        self._thisptr = shared_ptr[_ch.CalibrationHelper](
            new _hm.HestonModelHelper(
                deref(maturity._thisptr),
                deref(calendar._thisptr),
                s0,
                strike_price,
                volatility_handle,
                risk_free_rate._thisptr,
                dividend_yield._thisptr,
                error_type
            )
        )

cdef class HestonModel(CalibratedModel):

    def __init__(self, HestonProcess process):

        self._thisptr = shared_ptr[_mo.CalibratedModel](
            new _hm.HestonModel(static_pointer_cast[_hp.HestonProcess](
                process._thisptr))
        )

    cdef inline _hm.HestonModel* as_ptr(self) nogil:
        return <_hm.HestonModel*>self._thisptr.get()

    def process(self):
        cdef HestonProcess process = HestonProcess.__new__(HestonProcess)
        process._thisptr = static_pointer_cast[_sp.StochasticProcess](
            self.as_ptr().process())
        return process

    property theta:
        def __get__(self):
            return self.as_ptr().theta()

    property kappa:
        def __get__(self):
            return self.as_ptr().kappa()

    property sigma:
        def __get__(self):
            return self.as_ptr().sigma()

    property rho:
        def __get__(self):
            return self.as_ptr().rho()

    property v0:
        def __get__(self):
            return self.as_ptr().v0()
