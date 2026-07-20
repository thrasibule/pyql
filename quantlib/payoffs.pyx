include 'types.pxi'
from cython.operator import dereference as deref

from .option cimport OptionType

cdef inline _payoffs.PlainVanillaPayoff* _get_payoff(PlainVanillaPayoff payoff):
    return <_payoffs.PlainVanillaPayoff*> payoff._thisptr.get()

cdef class Payoff:
    """Abstract base class for option payoffs.

    This class defines the interface for payoff functions. A payoff
    can be called as a function of the underlying price at exercise.
    """

    def __str__(self):
        if self._thisptr:
            return self._thisptr.get().description().decode('utf-8')
        else:
            raise ValueError("empty payoff")

    def __call__(self, Real price):
        """Returns the payoff value for a given underlying price.

        Parameters
        ----------
        price : float
            The price of the underlying asset at exercise.

        Returns
        -------
        float
            The payoff value.
        """
        return deref(self._thisptr)(price)


cdef class StrikedTypePayoff(Payoff):
    """Intermediate class for put/call payoffs.

    Adds the concept of an option type (Call or Put) to the base
    Payoff class.
    """
    pass


cdef class PlainVanillaPayoff(StrikedTypePayoff):
    """Plain vanilla payoff.

    The payoff for a plain vanilla option is:

    - Call: :math:`\max(S - K, 0)`
    - Put: :math:`\max(K - S, 0)`

    where :math:`S` is the underlying price and :math:`K` is the strike.

    Parameters
    ----------
    option_type : :class:`~quantlib.option.OptionType`
        The type of option, can be either ``Call`` or ``Put``.
    strike : float
        The strike value.
    """

    def __init__(self, OptionType option_type, double strike):

        self._thisptr = shared_ptr[_payoffs.Payoff](
            new _payoffs.PlainVanillaPayoff(
                option_type, <Real>strike
            )
        )

    @property
    def option_type(self):
        """Returns the option type (Call or Put).

        Returns
        -------
        :class:`~quantlib.option.OptionType`
        """
        return _get_payoff(self).optionType()

    property strike:
        """Returns the strike value.

        Returns
        -------
        float
        """
        def __get__(self):
            return _get_payoff(self).strike()
