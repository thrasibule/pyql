from cython.operator cimport dereference as deref, preincrement as preinc
from libcpp cimport bool
from libcpp.vector cimport vector
from libcpp.utility cimport move
from quantlib.ext cimport optional

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
    """Payment schedule.

    A Schedule is a series of dates that determines the payment or
    accrual dates of financial instruments. It can be constructed from
    a rule (backward or forward generation) or from an explicit list of
    dates.

    The Schedule class provides methods to inspect the generated dates,
    to iterate over them, and to determine previous/next dates relative
    to a reference date.

    .. note::
        Prefer using the :meth:`from_rule` or :meth:`from_dates`
        class methods instead of the deprecated constructor.
    """

    def __init__(self, Date effective_date not None, Date termination_date not None,
            Period tenor not None, Calendar calendar not None,
            BusinessDayConvention business_day_convention=Following,
            BusinessDayConvention termination_date_convention=Following,
            DateGeneration date_generation_rule=DateGeneration.Forward, bool end_of_month=False,
           ):
        """.. deprecated::
            Use :meth:`from_rule` instead.
        """
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
        """Construct a Schedule from an explicit list of dates.

        Parameters
        ----------
        dates : list of :class:`~quantlib.time.date.Date`
            The list of dates. Neither the list nor the meta information
            is checked for plausibility.
        calendar : :class:`~quantlib.time.calendar.Calendar`, optional
            The calendar used to adjust dates. Defaults to
            :class:`~quantlib.time.calendars.null_calendar.NullCalendar`.
        business_day_convention : int, optional
            Business day convention for adjusting dates. Defaults to
            ``Unadjusted``.
        termination_date_convention : int, optional
            Specific business day convention for the termination date.
        tenor : :class:`~quantlib.time.date.Period`, optional
            The tenor (period) between dates.
        rule : :class:`~quantlib.time.dategeneration.DateGeneration`, optional
            The date generation rule used to generate the schedule.
        end_of_month : bool, optional
            Whether to use end-of-month rule for dates.
        is_regular : list of bool, optional
            A list indicating whether each date is regular.

        Returns
        -------
        :class:`Schedule`
            A new Schedule instance.
        """
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
        """Construct a Schedule from a date generation rule.

        Parameters
        ----------
        effective_date : :class:`~quantlib.time.date.Date`
            The first date of the schedule (e.g., start of the swap).
        termination_date : :class:`~quantlib.time.date.Date`
            The last date of the schedule (e.g., maturity).
        tenor : :class:`~quantlib.time.date.Period`
            The regular tenor (period) between dates.
        calendar : :class:`~quantlib.time.calendar.Calendar`
            The calendar used to adjust dates.
        business_day_convention : int, optional
            Business day convention for adjusting regular dates.
            Defaults to ``Following``.
        termination_date_convention : int, optional
            Business day convention for adjusting the termination date.
            Defaults to ``Following``.
        rule : :class:`~quantlib.time.dategeneration.DateGeneration`, optional
            The date generation rule. Defaults to ``Forward``.
        end_of_month : bool, optional
            Whether to use end-of-month rule for dates.
        first_date : :class:`~quantlib.time.date.Date`, optional
            Optional first date (used for short/long stub).
        next_to_lastdate : :class:`~quantlib.time.date.Date`, optional
            Optional next-to-last date (used for short/long stub).

        Returns
        -------
        :class:`Schedule`
            A new Schedule instance.
        """

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
        """Returns the list of dates of the schedule.

        Returns
        -------
        list of :class:`~quantlib.time.date.Date`
        """
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
        """Returns the first schedule date after the given reference date.

        Parameters
        ----------
        reference_date : :class:`~quantlib.time.date.Date`
            The reference date.

        Returns
        -------
        :class:`~quantlib.time.date.Date`
        """
        cdef _date.Date dt = self._thisptr.nextDate(
            reference_date._thisptr
        )
        return date_from_qldate(dt)

    def previous_date(self, Date reference_date):
        """Returns the last schedule date before the given reference date.

        Parameters
        ----------
        reference_date : :class:`~quantlib.time.date.Date`
            The reference date.

        Returns
        -------
        :class:`~quantlib.time.date.Date`
        """
        cdef _date.Date dt = self._thisptr.previousDate(
            reference_date._thisptr
        )
        return date_from_qldate(dt)

    def size(self):
        """Returns the number of dates in the schedule.

        Returns
        -------
        int
        """
        return self._thisptr.size()

    def at(self, int index):
        """Returns the date at the given index.

        Parameters
        ----------
        index : int
            The index of the date to retrieve.

        Returns
        -------
        :class:`~quantlib.time.date.Date`

        Raises
        ------
        IndexError
            If the index is out of bounds.
        """
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
    """Returns the date on or before date ``d`` that is the 20th of the
    month and observes the given date generation rule if relevant.

    Parameters
    ----------
    d : :class:`~quantlib.time.date.Date`
        The reference date.
    rule : :class:`~quantlib.time.dategeneration.DateGeneration`
        The date generation rule.

    Returns
    -------
    :class:`~quantlib.time.date.Date`
    """
    cdef _date.Date date = _schedule.previousTwentieth(d._thisptr, rule)
    return date_from_qldate(date)
