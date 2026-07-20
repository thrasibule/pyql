from cython.operator cimport dereference as deref, preincrement as preinc
from cpython.datetime cimport PyDate_Check, date_year, date_month, date_day, import_datetime
from libcpp.vector cimport vector

from quantlib.time.date cimport Date, date_from_qldate
from quantlib.time._date cimport Date as QlDate, Month
from libcpp.utility cimport pair
from libcpp.map cimport map

import_datetime()

cdef class TimeSeries:
    """Container for historical data.

    This class acts as a generic repository for a set of historical data.
    Any single datum can be accessed through its date, while sets of
    consecutive data can be accessed through iterators.

    Parameters
    ----------
    dates : list of :class:`~quantlib.time.date.Date` or :py:class:`datetime.date`
        The list of dates for the historical data.
    values : list of float
        The list of values corresponding to each date.
    """

    def __init__(self, list dates, list values):
        cdef:
            vector[QlDate] qldates
            vector[Real] qlvalues
            Real v
        for d, v in zip(dates, values):
            if PyDate_Check(d):
                qldates.push_back(QlDate(date_day(d), <Month>date_month(d), date_year(d)))
            elif isinstance(d, Date):
                qldates.push_back((<Date>d)._thisptr)
            qlvalues.push_back(<Real?>v)

        self._thisptr = _ts.TimeSeries[Real](qldates.begin(), qldates.end(), qlvalues.begin())

    @property
    def first_date(self):
        """Returns the first date for which a historical datum exists.

        Returns
        -------
        :class:`~quantlib.time.date.Date`
        """
        return date_from_qldate(self._thisptr.firstDate())

    @property
    def last_date(self):
        """Returns the last date for which a historical datum exists.

        Returns
        -------
        :class:`~quantlib.time.date.Date`
        """
        return date_from_qldate(self._thisptr.lastDate())

    def __iter__(self):

        cdef map[QlDate, double].const_iterator it = self._thisptr.const_begin()
        while it != self._thisptr.const_end():
            yield (date_from_qldate(deref(it).first), deref(it).second)
            preinc(it)

    def __len__(self):
        """Returns the number of historical data points.

        Returns
        -------
        int
        """
        return self._thisptr.size()

    def __bool__(self):
        """Returns whether the series contains any data.

        Returns
        -------
        bool
        """
        return not self._thisptr.empty()

    def __getitem__(self, Date date not None):
        """Returns the datum corresponding to the given date.

        Parameters
        ----------
        date : :class:`~quantlib.time.date.Date`
            The date for which to retrieve the historical datum.

        Returns
        -------
        float
        """
        return self._thisptr[date._thisptr]

    def __setitem__(self, Date date, value):
        """Sets the datum corresponding to the given date.

        Parameters
        ----------
        date : :class:`~quantlib.time.date.Date`
            The date for which to set the historical datum.
        value : float
            The value to store.
        """
        self._thisptr[date._thisptr] = value
