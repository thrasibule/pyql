# Copyright (C) 2013, Enthought Inc
# Copyright (C) 2013, Patrick Henaff

# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the license for more details.

""" Interest rate swap"""

from quantlib.types cimport Size
from quantlib.cashflow cimport Leg
cimport quantlib.time._date as _date
from quantlib.time.date cimport date_from_qldate
from quantlib._cashflow cimport Leg as QlLeg

from . cimport _swap

cdef inline _swap.Swap* get_swap(Swap swap) noexcept:
    """ Utility function to extract a properly casted Swap pointer out of the
    internal _thisptr attribute of the Instrument base class. """

    return <_swap.Swap*>swap._thisptr.get()


cdef class Swap(Instrument):
    """
    Base swap class
    """
    Payer = Type.Payer
    Receiver = Type.Receiver

    def __init__(self, Leg first_leg, Leg second_leg):
        """ The cash flows belonging to the first leg are paid;
        the ones belonging to the second leg are received"""

        self._thisptr.reset(new _swap.Swap(first_leg._thisptr, second_leg._thisptr))

    property start_date:
        def __get__(self):
            cdef _date.Date dt = get_swap(self).startDate()
            return date_from_qldate(dt)

    property maturity_date:
        def __get__(self):
            cdef _date.Date dt = get_swap(self).maturityDate()
            return date_from_qldate(dt)

    def leg_BPS(self, Size j):
        return get_swap(self).legBPS(j)

    def leg_NPV(self, Size j):
        return get_swap(self).legNPV(j)

    def startDiscounts(self, Size j):
        return get_swap(self).startDiscounts(j)

    def endDiscounts(self, Size j):
        return get_swap(self).endDiscounts(j)

    def npv_date_discount(self):
        return get_swap(self).npvDateDiscount()

    def leg(self, int i):
        cdef Leg leg = Leg.__new__(Leg)
        cdef _swap.Swap* swap = <_swap.Swap*>self._thisptr.get()
        if 0 <= i < swap.numberOfLegs():
            leg._thisptr = swap.legs()[i]
        else:
            raise IndexError(f"leg #{i} doesn't exist")
        return leg

    def __getitem__(self, int i):
        cdef Leg leg = Leg.__new__(Leg)
        cdef _swap.Swap* swap = <_swap.Swap*>self._thisptr.get()
        if 0 <= i < swap.numberOfLegs():
            leg._thisptr = swap.legs()[i]
        else:
            raise IndexError(f"leg #{i} doesn't exist")
        return leg
