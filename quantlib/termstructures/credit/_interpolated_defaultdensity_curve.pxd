include '../../types.pxi'

from libcpp.vector cimport vector

from quantlib.termstructures._default_term_structure cimport (
    DefaultProbabilityTermStructure )

from quantlib.time._date cimport Date
from quantlib.time._daycounter cimport DayCounter
from quantlib.time._calendar cimport Calendar

cdef extern from 'ql/termstructures/credit/interpolateddefaultdensitycurve.hpp' namespace 'QuantLib':

    cdef cppclass InterpolatedDefaultDensityCurve[I](DefaultProbabilityTermStructure):
        InterpolatedDefaultDensityCurve(const vector[Date]& dates,
                                    vector[Rate]& hazardRates,
                                    const DayCounter& dayCounter,
                                    const Calendar& cal # = Calendar()
        ) except +
        const vector[Time]& times()
        const vector[Real]& data()
        const vector[Rate]& defaultDensities()
        const vector[Date]& dates()
