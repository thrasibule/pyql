from quantlib.types cimport Rate, Real, Size
from . cimport _bond
cimport quantlib.time._date as _date

from cython.operator cimport dereference as deref
from libcpp.vector cimport vector
from libcpp cimport bool
from quantlib.cashflow cimport Leg
from quantlib.compounding cimport Compounding
from quantlib.time.businessdayconvention cimport BusinessDayConvention
from quantlib.time.calendar cimport Calendar
from quantlib.time.date cimport Date, date_from_qldate, Period
from quantlib.time.daycounter cimport DayCounter
from quantlib.time._period cimport Frequency

cdef class Price:
    Clean = Type.Clean
    Dirty = Type.Dirty

cdef class Bond(Instrument):
    """ Base bond class

        .. warning::

            Most methods assume that the cash flows are stored
            sorted by date, the redemption(s) being after any
            cash flow at the same date. In particular, if there's
            one single redemption, it must be the last cash flow,

    """
    def __init__(self):
        raise NotImplementedError('Cannot instantiate a Bond. Please use child classes.')

    cdef inline _bond.Bond* as_ptr(self):
        return <_bond.Bond*>self._thisptr.get()

    @property
    def settlement_days(self):
        return self.as_ptr().settlementDays()

    @property
    def calendar(self):
        cdef Calendar c = Calendar.__new__(Calendar)
        c._thisptr = self.as_ptr().calendar()
        return c

    @property
    def start_date(self):
        """ Bond start date"""
        return date_from_qldate(self.as_ptr().startDate())


    @property
    def maturity_date(self):
        """ Bond maturity date"""
        return date_from_qldate(self.as_ptr().maturityDate())

    @property
    def issue_date(self):
        """ Bond issue date"""
        return date_from_qldate(self.as_ptr().issueDate())

    def settlement_date(self, Date from_date=Date()):
        """ Returns the bond settlement date after the given date."""
        return date_from_qldate(self.as_ptr().settlementDate(deref(from_date._thisptr)))

    def clean_price(self, Rate y, DayCounter dc, Compounding comp, Frequency freq, Date settlement_date=Date()):
        return self.as_ptr().cleanPrice(
            y, deref(dc._thisptr), comp, freq, deref(settlement_date._thisptr)
        )

    @property
    def dirty_price(self):
        """ Bond dirty price"""
        return self.as_ptr().dirtyPrice()

    def bond_yield(self, Real price, DayCounter dc not None,
                   Compounding comp, Frequency freq,
                   Date settlement_date=Date(), Real accuracy=1e-08,
                   Size max_evaluations=100, Real guess=0.5, Type price_type = Price.Clean):
        """ Return the yield given a price and settlement date

        The default bond settlement is used if no date is given.

        This method is the original Bond.yield method in C++.
        Python does not allow us to use the yield statement as a method name.

        """
        return self.as_ptr().bond_yield(
                price, deref(dc._thisptr), comp,
                freq, deref(settlement_date._thisptr),
                accuracy, max_evaluations, guess, price_type
            )

    def accrued_amount(self, Date date=Date()):
        """ Returns the bond accrued amount at the given date"""
        return self.as_ptr().accruedAmount(deref(date._thisptr))

    @property
    def cashflows(self):
        """ cash flow stream as a Leg """
        cdef Leg leg = Leg.__new__(Leg)
        leg._thisptr = self.as_ptr().cashflows()
        return leg

    def notional(self, Date date=Date()):
        return self.as_ptr().notional(deref(date._thisptr))
