# Copyright (C) 2013, Enthought Inc
# Copyright (C) 2013, Patrick Henaff
# Copyright (c) 2012 BG Research LLC
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the license for more details.

cimport _cashflow as _cf
cimport quantlib.time._date as _date
cimport quantlib.time.date as date

from libcpp.vector cimport vector
from cython.operator cimport dereference as deref
from quantlib.handle cimport shared_ptr


cdef class CashFlow:
    """Abstract Base Class.

    Use SimpleCashFlow instead

    """
    def __init__(self):
        raise ValueError(
            'This is an abstract class.'
        )

    property date:
        def __get__(self):
            cdef _date.Date cf_date
            if self._thisptr.get():
                cf_date = self._thisptr.get().date()
                return date.date_from_qldate(cf_date)
            else:
                return None

    property amount:
        def __get__(self):
            if self._thisptr.get():
                return self._thisptr.get().amount()
            else:
                return None


cdef class SimpleCashFlow(CashFlow):

    def __init__(self, Real amount, date.Date cfdate):

        self._thisptr = shared_ptr[_cf.CashFlow](
            new _cf.SimpleCashFlow(amount, deref(cfdate._thisptr))
        )

    def __str__(self):
        return 'Simple Cash Flow: {:f}, {!s}'.format(
            self.amount, self.date
        )

cdef object leg_items(const vector[shared_ptr[_cf.CashFlow]]& leg):
    """
    Returns a list of (amount, pydate)
    """
    cdef size_t i
    cdef shared_ptr[_cf.CashFlow] _thiscf

    itemlist = []
    for i in xrange(leg.size()):
        _thiscf = leg.at(i)

        itemlist.append(
            (
                _thiscf.get().amount(),
                date._pydate_from_qldate(_thiscf.get().date())
            )
        )
    return itemlist

cdef class SimpleLeg:


    def __init__(self, leg = None):
        '''Takes as input a list of (amount, QL Date) tuples. '''

        #TODO: make so that it handles pydate as well as QL Dates.
        cdef shared_ptr[_cf.CashFlow] _thiscf

        for _amount, _date in leg:

            _thiscf = shared_ptr[_cf.CashFlow](
                new _cf.SimpleCashFlow(_amount,
                                       deref((<date.Date>_date)._thisptr))
            )

            self._thisptr.push_back(_thiscf)

    property size:
        def __get__(self):
            cdef int size = self._thisptr.size()
            return size

    property items:
        def __get__(self):
            '''Return Leg as (amount, date) list. '''

            return leg_items(self._thisptr)

    def __repr__(self):
            """ Pretty print cash flow schedule. """
            _items = self.items[:]

            header = "Cash Flow Schedule:\n"
            values = ("{0[1]!s} {0[0]:f}".format(_it) for _it in _items)
            return header + '\n'.join(values)
