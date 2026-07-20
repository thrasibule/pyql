"""Purely virtual base class for market observables."""
from quantlib.ext cimport static_pointer_cast
from quantlib._observable cimport Observable as QlObservable

cdef class Quote(Observable):
    """Purely virtual base class for market observables.

    A Quote is an object that holds a market value and can notify
    observers when the value changes. This is the base class for all
    market data elements such as prices, rates, and volatilities.

    .. note::
        This is an abstract class. Use :class:`~quantlib.quotes.simplequote.SimpleQuote`
        for a concrete implementation.
    """

    def __init__(self):
        raise ValueError(
            'This is an abstract class. Use SimpleQuote instead.'
        )

    property is_valid:
        """Returns ``True`` if the Quote holds a valid value.

        Returns
        -------
        bool
        """
        def __get__(self):
            return self._thisptr.get().isValid()

    property value:
        """Returns the current value of the quote.

        Returns
        -------
        float
        """
        def __get__(self):
            return self._thisptr.get().value()

    def __bool__(self):
        return self._thisptr.get().isValid()

    cdef shared_ptr[QlObservable] as_observable(self) noexcept nogil:
        return static_pointer_cast[QlObservable](self._thisptr)

    cdef inline Handle[_qt.Quote] handle(self):
        if not self._thisptr:
            return Handle[_qt.Quote]()
        else:
            return Handle[_qt.Quote](self._thisptr)

    @staticmethod
    cdef inline Handle[_qt.Quote] empty_handle():
        return Handle[_qt.Quote]()
