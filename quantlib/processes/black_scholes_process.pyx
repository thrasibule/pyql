include '../types.pxi'

from . cimport _black_scholes_process as _bsp
cimport quantlib._stochastic_process as _sp

from quantlib.quote cimport Quote
from quantlib.handle cimport HandleBlackVolTermStructure, HandleYieldTermStructure


cdef class GeneralizedBlackScholesProcess(StochasticProcess1D):
    r"""Generalized Black-Scholes stochastic process.

    This class describes the stochastic process :math:`S` governed by:

    .. math::
        d\ln S(t) = (r(t) - q(t) - \frac{\sigma(t, S)^2}{2}) dt
                   + \sigma dW_t.

    .. warning::
        While the interface is expressed in terms of :math:`S`,
        the internal calculations work on :math:`\ln S`.

    This is a base class for specific Black-Scholes variants:

    - :class:`BlackScholesProcess` — stock with no dividends
    - :class:`BlackScholesMertonProcess` — stock with continuous dividends
    - ``BlackProcess`` — forward/futures contracts
    - ``GarmanKohlagenProcess`` — foreign exchange rates
    """
    pass

cdef class BlackScholesProcess(GeneralizedBlackScholesProcess):
    r"""Black-Scholes (1973) stochastic process.

    This class describes the stochastic process :math:`S` for a stock
    given by:

    .. math::
        d\ln S(t) = (r(t) - \frac{\sigma(t, S)^2}{2}) dt
                   + \sigma dW_t.

    Parameters
    ----------
    x0 : :class:`~quantlib.quote.Quote`
        The initial value of the underlying asset.
    risk_free_ts : :class:`~quantlib.handle.HandleYieldTermStructure`
        The risk-free rate term structure.
    black_vol_ts : :class:`~quantlib.handle.HandleBlackVolTermStructure`
        The Black volatility term structure.
    """

    def __init__(self, Quote x0 not None, HandleYieldTermStructure risk_free_ts not None,
                 HandleBlackVolTermStructure black_vol_ts not None):

        self._thisptr.reset( new \
            _bsp.BlackScholesProcess(
                x0.handle(),
                risk_free_ts.handle(),
                black_vol_ts.handle()
            )
        )

cdef class BlackScholesMertonProcess(GeneralizedBlackScholesProcess):
    r"""Merton (1973) extension to the Black-Scholes stochastic process.

    This class describes the stochastic process :math:`\ln S` for a stock
    or stock index paying a continuous dividend yield given by:

    .. math::
        d\ln S(t, S) = (r(t) - q(t) - \frac{\sigma(t, S)^2}{2}) dt
                     + \sigma dW_t.

    Parameters
    ----------
    x0 : :class:`~quantlib.quote.Quote`
        The initial value of the underlying asset.
    dividend_ts : :class:`~quantlib.handle.HandleYieldTermStructure`
        The dividend yield term structure.
    risk_free_ts : :class:`~quantlib.handle.HandleYieldTermStructure`
        The risk-free rate term structure.
    black_vol_ts : :class:`~quantlib.handle.HandleBlackVolTermStructure`
        The Black volatility term structure.
    """

    def __init__(self,
                 Quote x0 not None,
                 HandleYieldTermStructure dividend_ts not None,
                 HandleYieldTermStructure risk_free_ts not None,
                 HandleBlackVolTermStructure black_vol_ts not None):

        self._thisptr.reset( new \
            _bsp.BlackScholesMertonProcess(
                x0.handle(),
                dividend_ts.handle(),
                risk_free_ts.handle(),
                black_vol_ts.handle()
            )
        )
