"""This module contains "simple" Daycounter classes, i.e. which do not depend on
a convention"""

from cython.operator cimport dereference as deref
from libcpp cimport bool

cimport _simple
from quantlib.time.calendar cimport Calendar, TARGET

cdef class Actual365Fixed(DayCounter):

    def __cinit__(self):
        self._thisptr = <_daycounter.DayCounter*> new _simple.Actual365Fixed()


cdef class Actual360(DayCounter):

    def __cinit__(self, bool include_last_day=False):
        self._thisptr = <_daycounter.DayCounter*> new _simple.Actual360(include_last_day)


cdef class Business252(DayCounter):

    def __cinit__(self, Calendar calendar=TARGET()):
        self._thisptr = <_daycounter.DayCounter*> new _simple.Business252(deref(calendar._thisptr))


cdef class OneDayCounter(DayCounter):

    def __cinit__(self):
        self._thisptr = <_daycounter.DayCounter*> new _simple.OneDayCounter()


cdef class SimpleDayCounter(DayCounter):

    def __cinit__(self):
        self._thisptr = <_daycounter.DayCounter*> new _simple.SimpleDayCounter()
