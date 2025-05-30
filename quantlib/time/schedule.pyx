from cython.operator cimport dereference as deref, preincrement as preinc
from libcpp cimport bool
from libcpp.vector cimport vector
from libcpp.utility cimport move
from quantlib.handle cimport optional

cimport quantlib.time._date as _date
cimport quantlib.time._calendar as _calendar
cimport cython
import numpy as np
cimport numpy as np
np.import_array()
from .businessdayconvention cimport Following, Unadjusted, BusinessDayConvention
from .dategeneration cimport DateGeneration

from .calendar cimport Calendar
from .calendars.null_calendar cimport NullCalendar
from .date cimport date_from_qldate, Date, Period

import warnings

cdef class Schedule:
    """ Payment schedule. """

    def __init__(self, Date effective_date not None, Date termination_date not None,
            Period tenor not None, Calendar calendar not None,
            BusinessDayConvention business_day_convention=Following,
            BusinessDayConvention termination_date_convention=Following,
            DateGeneration date_generation_rule=DateGeneration.Forward, bool end_of_month=False,
           ):

        warnings.warn("Deprecated: use class method from_rule instead",
            DeprecationWarning)

        self._thisptr = move(
                _schedule.Schedule(
            effective_date._thisptr,
            termination_date._thisptr,
            deref(tenor._thisptr),
            calendar._thisptr,
            business_day_convention,
            termination_date_convention,
            date_generation_rule, end_of_month,
            _date.Date(), _date.Date()
            )
        )

    @classmethod
    def from_dates(cls, dates, Calendar calendar=NullCalendar(),
            BusinessDayConvention business_day_convention=Unadjusted,
            termination_date_convention=None,
            Period tenor=None,
            rule=None,
            end_of_month=None,
            vector[bool] is_regular=[]):
        # convert lists to vectors
        cdef vector[_date.Date] _dates
        cdef Date date
        for date in dates:
            _dates.push_back(date._thisptr)

        cdef Schedule instance = Schedule.__new__(Schedule)
        cdef optional[BusinessDayConvention] opt_termination_convention
        cdef optional[_calendar.Period] opt_tenor
        cdef optional[DateGeneration] opt_rule
        cdef optional[bool] opt_end_of_month
        if tenor is not None:
            opt_tenor = deref(tenor._thisptr)
        if termination_date_convention is not None:
            opt_termination_convention = <BusinessDayConvention>termination_date_convention
        if rule is not None:
            opt_rule = <DateGeneration>rule
        if end_of_month is not None:
            opt_end_of_month = <bool>end_of_month
        instance._thisptr = move(_schedule.Schedule(
            _dates,
            calendar._thisptr,
            business_day_convention,
            opt_termination_convention,
            opt_tenor,
            opt_rule,
            opt_end_of_month,
            is_regular
        ))

        return instance

    @classmethod
    def from_rule(cls, Date effective_date not None,
                  Date termination_date not None,
                  Period tenor not None, Calendar calendar not None,
                  BusinessDayConvention business_day_convention=Following,
                  BusinessDayConvention termination_date_convention=Following,
                  DateGeneration rule=DateGeneration.Forward, bool end_of_month=False,
                  Date first_date=Date(), Date next_to_lastdate=Date()):

        cdef Schedule instance = Schedule.__new__(Schedule)
        instance._thisptr = move(_schedule.Schedule(
            effective_date._thisptr,
            termination_date._thisptr,
            deref(tenor._thisptr),
            calendar._thisptr,
            business_day_convention,
            termination_date_convention,
            rule, end_of_month,
            first_date._thisptr, next_to_lastdate._thisptr
            ))
        return instance

    def dates(self):
        cdef vector[_date.Date] dates = self._thisptr.dates()
        cdef list t = []
        cdef _date.Date d
        for d in dates:
            t.append(date_from_qldate(d))
        return t

    @cython.boundscheck(False)
    def to_npdates(self):
        cdef np.ndarray[np.int64_t] dates = np.empty(self._thisptr.size(), dtype=np.int64)
        cdef vector[_date.Date].const_iterator it = self._thisptr.begin()
        cdef size_t i = 0
        while it != self._thisptr.end():
            dates[i] = deref(it).serialNumber() - 25569
            i += 1
            preinc(it)
        return dates.view('M8[D]')

    def next_date(self, Date reference_date):
        cdef _date.Date dt = self._thisptr.nextDate(
            reference_date._thisptr
        )
        return date_from_qldate(dt)

    def previous_date(self, Date reference_date):
        cdef _date.Date dt = self._thisptr.previousDate(
            reference_date._thisptr
        )
        return date_from_qldate(dt)

    def size(self):
        return self._thisptr.size()

    def at(self, int index):
        cdef _date.Date date = self._thisptr.at(index)
        return date_from_qldate(date)

    def __iter__(self):
        cdef vector[_date.Date].const_iterator it = self._thisptr.begin()
        while it != self._thisptr.end():
            yield date_from_qldate(deref(it))
            preinc(it)

    def __len__(self):
        return self._thisptr.size()

    def __getitem__(self, index):
        cdef size_t i
        if isinstance(index, slice):
            return [date_from_qldate(self._thisptr.at(i))
                    for i in range(*index.indices(self._thisptr.size()))]
        elif isinstance(index, int):
            if index < 0:
                index += self._thisptr.size()
            if index < 0:
                raise IndexError
            return date_from_qldate(self._thisptr.at(index))
        else:
            raise TypeError('index needs to be an integer or a slice')

def previous_twentieth(Date d not None, DateGeneration rule):
    cdef _date.Date date = _schedule.previousTwentieth(d._thisptr, rule)
    return date_from_qldate(date)
