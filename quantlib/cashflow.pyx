"""
 Copyright (C) 2013, Enthought Inc
 Copyright (C) 2013, Patrick Henaff
 Copyright (c) 2012 BG Research LLC

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""

cimport _cashflow as _cf
cimport quantlib.time._date as _date
cimport quantlib.time.date as date

from libcpp.vector cimport vector
from cython.operator cimport dereference as deref, preincrement as inc
from quantlib.handle cimport shared_ptr

import numpy as np
cimport numpy as np
cimport cython

cdef class CashFlow:
    """Abstract Base Class.

    Use SimpleCashFlow instead

    """
    def __cinit__(self):
        self._thisptr = NULL

    def __init__(self):
        raise ValueError(
            'This is an abstract class.'
        )

    def __dealloc__(self):
        if self._thisptr is not NULL:
            del self._thisptr

    property date:
        def __get__(self):
            cdef _date.Date cf_date
            if self._thisptr:
                cf_date = self._thisptr.get().date()
                return date.date_from_qldate(cf_date)
            else:
                return None

    property amount:
        def __get__(self):
            if self._thisptr:
                return self._thisptr.get().amount()
            else:
                return None


cdef class SimpleCashFlow(CashFlow):

    def __init__(self, Real amount, date.Date cfdate):
        cdef _date.Date* _cfdate = cfdate._thisptr.get()

        self._thisptr = new shared_ptr[_cf.CashFlow](
            new _cf.SimpleCashFlow(amount, deref(_cfdate))
        )

    def __str__(self):
        return 'Simple Cash Flow: {:f}, {!s}'.format(
            self.amount, self.date
        )

cdef list leg_items(const vector[shared_ptr[_cf.CashFlow]]& leg):
    """
    Returns a list of (amount, pydate)
    """
    cdef size_t i
    cdef shared_ptr[_cf.CashFlow] _thiscf

    cdef list itemlist = []
    for i in range(leg.size()):
        _thiscf = leg.at(i)

        itemlist.append(
            (
                _thiscf.get().amount(),
                date._pydate_from_qldate(_thiscf.get().date())
            )
        )
    return itemlist

cdef class SimpleLeg:

    def __cinit__(self):
        self._thisptr = vector[shared_ptr[_cf.CashFlow]]()

    def __init__(self, leg=None):
        '''Takes as input a list of (amount, QL Date) tuples. '''
        if leg is None:
            return

        #TODO: make so that it handles pydate as well as QL Dates.
        cdef shared_ptr[_cf.CashFlow] _thiscf
        cdef _date.Date *_thisdate

        for _amount, _date in leg:
            _thisdate = (<date.Date?>_date)._thisptr.get()

            _thiscf = shared_ptr[_cf.CashFlow](
                new _cf.SimpleCashFlow(_amount, deref(_thisdate))
            )

            self._thisptr.push_back(_thiscf)

    property size:
        def __get__(self):
            cdef int size = self._thisptr.size()
            return size

    property items:
        def __get__(self):
            '''Return Leg as (amount, date) list. '''

            cdef vector[shared_ptr[_cf.CashFlow]] leg = self._thisptr
            return leg_items(leg)

    @cython.boundscheck(False)
    @cython.wraparound(False)
    def toarray(self):
        """Return Leg as (dates, amounts) where date is a datetime64['D']
        numpy array, and amounts a float64 numpy array"""
        cdef vector[shared_ptr[_cf.CashFlow]] leg = self._thisptr
        cdef _cf.CashFlow* _thiscf
        cdef np.ndarray[np.int64_t] dates = np.empty(leg.size(), dtype = np.int64)
        cdef np.ndarray[np.float64_t] amounts = np.empty(leg.size(), dtype = np.float64)

        cdef vector[shared_ptr[_cf.CashFlow]].iterator it = leg.begin()
        cdef size_t i = 0
        while it != leg.end():
            _thiscf = deref(it).get()
            dates[i] = _thiscf.date().serialNumber()-25569
            amounts[i] = _thiscf.amount()
            i = i + 1
            inc(it)

        return amounts, dates.view('M8[D]')

    def __repr__(self):
        """ Pretty print cash flow schedule. """
        _items = self.items[:]

        header = "Cash Flow Schedule:\n"
        values = ("{0[1]!s} {0[0]:f}".format(_it) for _it in _items)
        return header + '\n'.join(values)
