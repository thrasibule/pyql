from quantlib.types cimport Real, Size
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
    """Bond price information.

    Parameters
    ----------
    amount : float
        The price amount.
    type : :class:`~quantlib.instruments.bonds.bond.Price.Type`, optional
        The price type, either `Clean` or `Dirty`.
    """
    Clean = Type.Clean
    Dirty = Type.Dirty

    def __init__(self, Real amount, Type type=Price.Clean):
        self._this =_bond.Bond.Price(amount, type)

    @property
    def amount(self):
        """The price amount."""
        return self._this.amount()

    @property
    def type(self):
        """The price type."""
        return self._this.type()

cdef class Bond(Instrument):
    """Base bond class.

    .. warning::

        Most methods assume that the cash flows are stored
        sorted by date, the redemption(s) being after any
        cash flow at the same date. In particular, if there's
        one single redemption, it must be the last cash flow.
    """
    def __init__(self):
        raise NotImplementedError('Cannot instantiate a Bond. Please use child classes.')

    cdef inline _bond.Bond* as_ptr(self):
        return <_bond.Bond*>self._thisptr.get()

    @property
    def settlement_days(self):
        """The number of settlement days for the bond."""
        return self.as_ptr().settlementDays()

    @property
    def calendar(self):
        """The calendar for the bond."""
        cdef Calendar c = Calendar.__new__(Calendar)
        c._thisptr = self.as_ptr().calendar()
        return c

    @property
    def start_date(self):
        """The bond's start date."""
        return date_from_qldate(self.as_ptr().startDate())


    @property
    def maturity_date(self):
        """The bond's maturity date."""
        return date_from_qldate(self.as_ptr().maturityDate())

    @property
    def issue_date(self):
        """The bond's issue date."""
        return date_from_qldate(self.as_ptr().issueDate())

    def settlement_date(self, Date from_date=Date()):
        """Returns the bond's settlement date after the given date.

        Parameters
        ----------
        from_date : :class:`~quantlib.time.date.Date`, optional
            The date from which to calculate the settlement date.
        """
        return date_from_qldate(self.as_ptr().settlementDate(from_date._thisptr))

    @property
    def clean_price(self):
        """The bond's clean price."""
        return self.as_ptr().cleanPrice()

    @property
    def dirty_price(self):
        """The bond's dirty price."""
        return self.as_ptr().dirtyPrice()

    def bond_yield(self, Price price, DayCounter dc not None,
                   Compounding comp, Frequency freq,
                   Date settlement_date=Date(), Real accuracy=1e-08,
                   Size max_evaluations=100, Real guess=0.05):
        """Returns the yield given a price and settlement date.

        The default bond settlement is used if no date is given.

        This method is the original Bond.yield method in C++.
        Python does not allow `yield` as a method name.

        Parameters
        ----------
        price : :class:`~quantlib.instruments.bonds.bond.Price`
            The price to be used for the yield calculation.
        dc : :class:`~quantlib.time.daycounter.DayCounter`
            The day counter.
        comp : :class:`~quantlib.compounding.Compounding`
            The compounding convention.
        freq : :class:`~quantlib.time.frequency.Frequency`
            The frequency.
        settlement_date : :class:`~quantlib.time.date.Date`, optional
            The settlement date.
        accuracy : float, optional
            The desired accuracy.
        max_evaluations : int, optional
            The maximum number of evaluations.
        guess : float, optional
            The initial guess for the yield.
        """
        return self.as_ptr().bond_yield(
                price._this, deref(dc._thisptr), comp,
                freq, settlement_date._thisptr,
                accuracy, max_evaluations, guess
            )

    def accrued_amount(self, Date date=Date()):
        """Returns the bond's accrued amount at the given date.

        Parameters
        ----------
        date : :class:`~quantlib.time.date.Date`, optional
            The date for which to calculate the accrued amount.
        """
        return self.as_ptr().accruedAmount(date._thisptr)

    @property
    def cashflows(self):
        """The bond's cash flow stream as a :class:`~quantlib.cashflow.Leg`."""
        cdef Leg leg = Leg.__new__(Leg)
        leg._thisptr = self.as_ptr().cashflows()
        return leg

    def notional(self, Date date=Date()):
        """Returns the bond's notional at the given date.

        Parameters
        ----------
        date : :class:`~quantlib.time.date.Date`, optional
            The date for which to retrieve the notional.
        """
        return self.as_ptr().notional(date._thisptr)
