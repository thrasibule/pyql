"""
 Copyright (C) 2011, Enthought Inc
 Copyright (C) 2011, Patrick Henaff

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""

from libcpp.vector cimport vector
from quantlib.types cimport Natural

from quantlib.handle cimport shared_ptr
from .._helpers cimport BootstrapHelper
from ._credit_helpers cimport DefaultProbabilityHelper
from .._default_term_structure cimport DefaultProbabilityTermStructure
from .._iterativebootstrap cimport IterativeBootstrap
from ._interpolated_defaultdensity_curve cimport InterpolatedDefaultDensityCurve
from ._interpolated_hazardrate_curve cimport InterpolatedHazardRateCurve
from ._interpolated_survivalprobability_curve cimport InterpolatedSurvivalProbabilityCurve

from quantlib.math.interpolation import L
from quantlib.time._date cimport Date
from quantlib.time._daycounter cimport DayCounter
from quantlib.time._calendar cimport Calendar

cdef extern from 'ql/termstructures/credit/probabilitytraits.hpp' namespace 'QuantLib':

    cdef cppclass HazardRate:
        cppclass curve[I]:
            ctypedef InterpolatedHazardRateCurve[I] type
        ctypedef BootstrapHelper[DefaultProbabilityTermStructure] helper

    cdef cppclass SurvivalProbability:
        cppclass curve[I]:
            ctypedef InterpolatedSurvivalProbabilityCurve[I] type
        ctypedef BootstrapHelper[DefaultProbabilityTermStructure] helper

    cdef cppclass DefaultDensity:
        cppclass curve[I]:
            ctypedef InterpolatedDefaultDensityCurve[I] type
        ctypedef BootstrapHelper[DefaultProbabilityTermStructure] helper


cdef extern from 'ql/termstructures/credit/piecewisedefaultcurve.hpp' namespace 'QuantLib':
    cdef cppclass PiecewiseDefaultCurve[T, I](InterpolatedHazardRateCurve[I], InterpolatedSurvivalProbabilityCurve[I], InterpolatedDefaultDensityCurve[I]):
        ctypedef IterativeBootstrap[PiecewiseDefaultCurve[T, I]] bootstrap_type
        PiecewiseDefaultCurve(Date& referenceDate,
                              vector[shared_ptr[DefaultProbabilityHelper]]& instruments,
                              DayCounter& dayCounter,
                              bootstrap_type bootstrap) except +
        PiecewiseDefaultCurve(Natural settlementDays,
                              Calendar& calendar,
                              vector[shared_ptr[DefaultProbabilityHelper]]& instruments,
                              DayCounter& dayCounter,
                              bootstrap_type bootstrap) except +
        PiecewiseDefaultCurve(Natural settlementDays,
                              Calendar& calendar,
                              vector[shared_ptr[DefaultProbabilityHelper]]& instruments,
                              DayCounter& dayCounter) except +,
        ctypedef T traits_type
