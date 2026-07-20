# Cython imports
from . cimport _option
from .exercise cimport Exercise
from .payoffs cimport Payoff

cdef class Option(Instrument):
    """Base option class.

    An option is a financial derivative that gives the holder the right,
    but not the obligation, to buy (Call) or sell (Put) an underlying
    asset at a specified strike price on or before a specified date.

    This is an abstract base class. Concrete implementations include
    :class:`~quantlib.instruments.vanillaoption.VanillaOption`.

    Attributes
    ----------
    Put : OptionType
        Put option type.
    Call : OptionType
        Call option type.
    """

    def __init__(self):
        raise NotImplementedError(
            'Cannot implement this abstract class. Use child like the '
            'VanillaOption'
        )

    Put = OptionType.Put
    Call = OptionType.Call

    def __str__(self):
        return '%s %s %s' % (
            type(self).__name__, str(self.exercise), str(self.payoff)
        )

    @property
    def exercise(self):
        """Returns the exercise associated with the option.

        Returns
        -------
        :class:`~quantlib.exercise.Exercise`
        """
        cdef Exercise ex = Exercise.__new__(Exercise)
        ex._thisptr = (<_option.Option*>self._thisptr.get()).exercise()
        return ex

    @property
    def payoff(self):
        """Returns the payoff associated with the option.

        Returns
        -------
        :class:`~quantlib.payoffs.Payoff`
        """
        cdef Payoff po = Payoff.__new__(Payoff)
        po._thisptr = (<_option.Option*>self._thisptr.get()).payoff()
        return po
