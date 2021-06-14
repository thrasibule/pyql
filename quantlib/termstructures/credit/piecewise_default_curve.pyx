from quantlib.types cimport Natural, Real
from cython.operator cimport dereference as deref, preincrement as preinc

from libcpp cimport bool
from libcpp.vector cimport vector
from libcpp.string cimport string

from . cimport _piecewise_default_curve as _pdc

from quantlib.handle cimport shared_ptr
from quantlib.time.date cimport Date, date_from_qldate
cimport quantlib.time._date as _date
from quantlib.time.daycounter cimport DayCounter
from quantlib.time.calendar cimport Calendar
cimport quantlib.termstructures.credit._credit_helpers as _ch
from .default_probability_helpers cimport CdsHelper, DefaultProbabilityHelper
cimport quantlib.termstructures._default_term_structure as _dts
from quantlib.termstructures.default_term_structure cimport DefaultProbabilityTermStructure

from enum import IntEnum

globals()["ProbabilityTrait"] = IntEnum('ProbabilityTrait',
        [('HazardRate', 0), ('DefaultDensity', 1), ('SurvivalProbability', 2)])
globals()["Interpolator"] = IntEnum('Interpolator',
        [('Linear', 0), ('LogLinear', 1), ('BackwardFlat', 2)])


cdef class PiecewiseDefaultCurve(DefaultProbabilityTermStructure):

    def __init__(self, ProbabilityTrait trait, Interpolator interpolator,
                 Natural settlement_days, Calendar calendar not None,
                 list helpers, DayCounter daycounter not None,
                 Real accuracy=1e-12):

        if len(helpers) == 0:
            raise ValueError('Cannot initialize curve with no helpers')

        # convert Python list to std::vector
        cdef vector[shared_ptr[_ch.DefaultProbabilityHelper]] instruments

        for helper in helpers:
            instruments.push_back((<DefaultProbabilityHelper?>helper)._thisptr)

        self._trait = trait
        self._interpolator = interpolator

        if trait == HazardRate:
            if interpolator == Linear:
                self.curve_type.hr_lin = new HR_LIN(
                    settlement_days, deref(calendar._thisptr), instruments,
                    deref(daycounter._thisptr), HR_LIN.bootstrap_type(accuracy))
                self._thisptr.reset(self.curve_type.hr_lin)
            elif interpolator == LogLinear:
                self.curve_type.hr_loglin = new HR_LOGLIN(
                    settlement_days, deref(calendar._thisptr), instruments,
                    deref(daycounter._thisptr), HR_LOGLIN.bootstrap_type(accuracy))
                self._thisptr.reset(self.curve_type.hr_loglin)
            else:
                self.curve_type.hr_backflat = new HR_BACKFLAT(
                    settlement_days, deref(calendar._thisptr), instruments,
                    deref(daycounter._thisptr), HR_BACKFLAT.bootstrap_type(accuracy))
                self._thisptr.reset(self.curve_type.hr_backflat)
        elif trait == DefaultDensity:
            if interpolator == Linear:
                self.curve_type.dd_lin = new DD_LIN(
                    settlement_days, deref(calendar._thisptr), instruments,
                    deref(daycounter._thisptr), DD_LIN.bootstrap_type(accuracy))
                self._thisptr.reset(self.curve_type.dd_lin)
            elif interpolator == LogLinear:
                self.curve_type.dd_loglin = new DD_LOGLIN(
                    settlement_days, deref(calendar._thisptr), instruments,
                    deref(daycounter._thisptr), DD_LOGLIN.bootstrap_type(accuracy))
                self._thisptr.reset(self.curve_type.dd_loglin)
            else:
                self.curve_type.dd_backflat = new DD_BACKFLAT(
                    settlement_days, deref(calendar._thisptr), instruments,
                    deref(daycounter._thisptr), DD_BACKFLAT.bootstrap_type(accuracy))
                self._thisptr.reset(self.curve_type.dd_backflat)
        else:
            if interpolator == Linear:
                self.curve_type.sp_lin = new SP_LIN(
                    settlement_days, deref(calendar._thisptr), instruments,
                    deref(daycounter._thisptr), SP_LIN.bootstrap_type(accuracy))
                self._thisptr.reset(self.curve_type.sp_lin)
            elif interpolator == LogLinear:
                self.curve_type.sp_loglin = new SP_LOGLIN(
                    settlement_days, deref(calendar._thisptr), instruments,
                    deref(daycounter._thisptr), SP_LOGLIN.bootstrap_type(accuracy))
                self._thisptr.reset(self.curve_type.sp_loglin)
            else:
                self.curve_type.sp_backflat = new SP_BACKFLAT(
                    settlement_days, deref(calendar._thisptr), instruments,
                    deref(daycounter._thisptr), SP_BACKFLAT.bootstrap_type(accuracy))
                self._thisptr.reset(self.curve_type.sp_backflat)


    @classmethod
    def from_reference_date(cls, ProbabilityTrait trait, Interpolator interpolator,
                            Date reference_date, list helpers,
                            DayCounter daycounter not None, Real accuracy=1e-12):

        if len(helpers) == 0:
            raise ValueError('Cannot initialize curve with no helpers')

        # convert Python list to std::vector
        cdef vector[shared_ptr[_ch.DefaultProbabilityHelper]] instruments

        cdef PiecewiseDefaultCurve instance = cls.__new__(cls)
        for helper in helpers:
            instruments.push_back(
                (<DefaultProbabilityHelper?>helper)._thisptr)

        instance._trait = trait
        instance._interpolator = interpolator

        if trait == HazardRate:
            if interpolator == Linear:
                instance.curve_type.hr_lin = new HR_LIN(
                    deref(reference_date._thisptr), instruments,
                    deref(daycounter._thisptr), HR_LIN.bootstrap_type(accuracy))
                instance._thisptr.reset(instance.curve_type.hr_lin)
            elif interpolator == LogLinear:
                instance.curve_type.hr_loglin = new HR_LOGLIN(
                    deref(reference_date._thisptr), instruments,
                    deref(daycounter._thisptr), HR_LOGLIN.bootstrap_type(accuracy))
                instance._thisptr.reset(instance.curve_type.hr_loglin)
            else:
                instance.curve_type.hr_backflat = new HR_BACKFLAT(
                    deref(reference_date._thisptr), instruments,
                    deref(daycounter._thisptr), HR_BACKFLAT.bootstrap_type(accuracy))
                instance._thisptr.reset(instance.curve_type.hr_backflat)
        elif trait == DefaultDensity:
            if interpolator == Linear:
                instance.curve_type.dd_lin = new DD_LIN(
                    deref(reference_date._thisptr), instruments,
                    deref(daycounter._thisptr), DD_LIN.bootstrap_type(accuracy))
                instance._thisptr.reset(instance.curve_type.dd_lin)
            elif interpolator == LogLinear:
                instance.curve_type.dd_loglin = new DD_LOGLIN(
                    deref(reference_date._thisptr), instruments,
                    deref(daycounter._thisptr), DD_LOGLIN.bootstrap_type(accuracy))
                instance._thisptr.reset(instance.curve_type.dd_loglin)
            else:
                instance.curve_type.dd_backflat = new DD_BACKFLAT(
                    deref(reference_date._thisptr), instruments,
                    deref(daycounter._thisptr), DD_BACKFLAT.bootstrap_type(accuracy))
                instance._thisptr.reset(instance.curve_type.dd_backflat)
        else:
            if interpolator == Linear:
                instance.curve_type.sp_lin = new SP_LIN(
                    deref(reference_date._thisptr), instruments,
                    deref(daycounter._thisptr), SP_LIN.bootstrap_type(accuracy))
                instance._thisptr.reset(instance.curve_type.sp_lin)
            elif interpolator == LogLinear:
                instance.curve_type.sp_loglin = new SP_LOGLIN(
                    deref(reference_date._thisptr), instruments,
                    deref(daycounter._thisptr), SP_LOGLIN.bootstrap_type(accuracy))
                instance._thisptr.reset(instance.curve_type.sp_loglin)
            else:
                instance.curve_type.sp_backflat = new SP_BACKFLAT(
                    deref(reference_date._thisptr), instruments,
                    deref(daycounter._thisptr), SP_BACKFLAT.bootstrap_type(accuracy))
                instance._thisptr.reset(instance.curve_type.sp_backflat)

        return instance

    @property
    def times(self):
        """list of curve times"""
        if self._trait == HazardRate:
            if self._interpolator == Linear:
                return self.curve_type.hr_lin.times()
            elif self._interpolator == LogLinear:
                return self.curve_type.hr_loglin.times()
            else:
                 return self.curve_type.hr_backflat.times()
        elif self._trait == DefaultDensity:
            if self._interpolator == Linear:
                return self.curve_type.dd_lin.times()
            elif self._interpolator == LogLinear:
                return self.curve_type.dd_loglin.times()
            else:
                 return self.curve_type.dd_backflat.times()
        else:
            if self._interpolator == Linear:
                return self.curve_type.sp_lin.times()
            elif self._interpolator == LogLinear:
                return self.curve_type.sp_loglin.times()
            else:
                 return self.curve_type.sp_backflat.times()

    @property
    def dates(self):
        """list of curve dates"""
        cdef vector[_date.Date] _dates

        if self._trait == HazardRate:
            if self._interpolator == Linear:
                _dates = self.curve_type.hr_lin.dates()
            elif self._interpolator == LogLinear:
                _dates = self.curve_type.hr_loglin.dates()
            else:
                _dates = self.curve_type.hr_backflat.dates()
        elif self._trait == DefaultDensity:
            if self._interpolator == Linear:
                _dates = self.curve_type.dd_lin.dates()
            elif self._interpolator == LogLinear:
                _dates = self.curve_type.dd_loglin.dates()
            else:
                 _dates = self.curve_type.dd_backflat.dates()
        else:
            if self._interpolator == Linear:
                _dates = self.curve_type.sp_lin.dates()
            elif self._interpolator == LogLinear:
                _dates = self.curve_type.sp_loglin.dates()
            else:
                 _dates = self.curve_type.sp_backflat.dates()
        cdef vector[_date.Date].const_iterator it = _dates.const_begin()
        cdef list r  = []

        while it != _dates.const_end():
            r.append(date_from_qldate(deref(it)))
            preinc(it)

        return r

    @property
    def data(self):
        """list of curve data"""
        if self._trait == HazardRate:
            if self._interpolator == Linear:
                return self.curve_type.hr_lin.data()
            elif self._interpolator == LogLinear:
                return self.curve_type.hr_loglin.data()
            else:
                 return self.hr_backflat.data()
        elif self._trait == DefaultDensity:
            if self._interpolator == Linear:
                return self.curve_type.dd_lin.data()
            elif self._interpolator == LogLinear:
                return self.curve_type.dd_loglin.data()
            else:
                 return self.curve_type.dd_backflat.data()
        else:
            if self._interpolator == Linear:
                return self.curve_type.sp_lin.data()
            elif self._interpolator == LogLinear:
                return self.curve_type.sp_loglin.data()
            else:
                 return self.curve_type.sp_backflat.data()
