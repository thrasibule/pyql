# Copyright (C) 2013, Enthought Inc
# Copyright (C) 2013, Patrick Henaff
# Copyright (c) 2012 BG Research LLC
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the license for more details.
from quantlib.types cimport Real
cimport quantlib._cashflow as _cf
cimport quantlib.time._date as _date

from quantlib.time.date cimport (
    Date, _qldate_from_pydate, _pydate_from_qldate, date_from_qldate)
from libcpp.vector cimport vector
from libcpp cimport bool
from cpython.datetime cimport date, import_datetime
from cython.operator cimport dereference as deref, preincrement as preinc
from quantlib.ext cimport shared_ptr, optional

import_datetime()

cdef class CashFlow:
    """Base class for cash flows.

    This class is purely abstract and acts as a base class for the
    actual cash flow implementations.

    .. note::
        Use :class:`SimpleCashFlow` for a concrete implementation.
    """

    @property
    def date(self):
        """Returns the date that the cash flow occurs.

        This is inherited from the Event class.

        Returns
        -------
        :class:`~quantlib.time.date.Date`
        """
        return date_from_qldate(self._thisptr.get().date())

    @property
    def amount(self):
        """Returns the amount of the cash flow.

        .. note::
            The amount is not discounted, i.e., it is the actual
            amount paid at the cash flow date.

        Returns
        -------
        float
        """
        return self._thisptr.get().amount()

    def has_occured(self, Date ref_date, include_ref_date=None):
        """Returns ``True`` if the cash flow has already occurred.

        Overloads ``Event.hasOccurred`` in order to take
        ``Settings.includeTodaysCashflows`` into account.

        Parameters
        ----------
        ref_date : :class:`~quantlib.time.date.Date`
            The reference date.
        include_ref_date : bool, optional
            Whether to include the reference date in the comparison.
            If ``None``, uses the global settings default.

        Returns
        -------
        bool
        """
        cdef _cf.CashFlow* cf = self._thisptr.get()
        cdef optional[bool] c_include_ref_date
        if include_ref_date is not None:
            c_include_ref_date = <bool>include_ref_date
        if cf:
            return cf.hasOccurred(ref_date._thisptr, c_include_ref_date)

cdef class SimpleCashFlow(CashFlow):
    """Concrete cash flow implementation.

    A simple cash flow that pays a fixed amount at a given date.

    Parameters
    ----------
    amount : float
        The amount of the cash flow.
    cfdate : :class:`~quantlib.time.date.Date`
        The date of the cash flow.
    """

    def __init__(self, Real amount, Date cfdate):
        self._thisptr = shared_ptr[_cf.CashFlow](
            new _cf.SimpleCashFlow(amount, cfdate._thisptr)
        )

    def __str__(self):
        return 'Simple Cash Flow: {:f}, {!s}'.format(
            self.amount, self.date
        )

cdef list leg_items(const _cf.Leg& leg):
    """Internal helper: returns a list of ``(amount, pydate)`` tuples from a C++ Leg."""
    cdef list itemlist = []
    cdef vector[shared_ptr[_cf.CashFlow]].const_iterator it = leg.const_begin()
    while it != leg.end():
        _thiscf = deref(it).get()
        itemlist.append((_thiscf.amount(),  _pydate_from_qldate(_thiscf.date())))
        preinc(it)
    return itemlist

cdef class Leg:
    """Sequence of cash flows.

    A Leg is a vector of cash flows that can be iterated over.
    It represents the payments leg of a financial instrument
    (e.g., the fixed or floating leg of a swap).

    Parameters
    ----------
    cashflows : list of :class:`CashFlow`
        A list of cash flow objects.
    """

    def __init__(self, cashflows: list[CashFlow]):
        cdef CashFlow cf
        for cf in cashflows:
            self._thisptr.push_back(cf._thisptr)

    def items(self):
        """Return the leg as a list of ``(amount, date)`` tuples.

        Returns
        -------
        list of tuple
            Each tuple contains ``(amount, pydate)``.
        """

        return leg_items(self._thisptr)

    def __len__(self):
        """Returns the number of cash flows in the leg.

        Returns
        -------
        int
        """
        cdef int size = self._thisptr.size()
        return size

    def __iter__(self):
        cdef CashFlow cf
        cdef vector[shared_ptr[_cf.CashFlow]].iterator it = self._thisptr.begin()
        while it != self._thisptr.end():
            cf = CashFlow.__new__(CashFlow)
            cf._thisptr = deref(it)
            yield cf
            preinc(it)

    def __repr__(self):
        """ Pretty print cash flow schedule. """

        header = "Cash Flow Schedule:\n"
        cdef list values = ["{0!s} {1:f}".format(d, cf) for cf, d in leg_items(self._thisptr)]
        return header + '\n'.join(values)
