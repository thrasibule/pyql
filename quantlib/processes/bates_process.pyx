"""
 Copyright (C) 2011, Enthought Inc
 Copyright (C) 2011, Patrick Henaff

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""

include '../types.pxi'

from cython.operator cimport dereference as deref
cimport quantlib._stochastic_process as _sp
from ._heston_process cimport BatesProcess as QlBatesProcess
from .heston_process cimport HestonProcess, Discretization, FullTruncation

from quantlib.ext cimport shared_ptr
from quantlib.quote cimport Quote
from quantlib.quotes.simplequote cimport SimpleQuote
from quantlib.handle cimport HandleYieldTermStructure

cdef class BatesProcess(HestonProcess):
    r"""Bates (1996) stochastic process.

    The Bates model extends the Heston model by adding a compound Poisson
    jump process to the stock price dynamics:

    .. math::
        dS_t = (r - d - \lambda \bar{k}) S_t dt
             + \sqrt{V_t} S_t dW_t^s + (e^{\ln(1+\bar{k})} - 1) S_t dN_t \\
        dV_t = \kappa (\theta - V_t) dt
             + \varepsilon \sqrt{V_t} dW_t^v

    where :math:`N_t` is a Poisson process with intensity :math:`\lambda`,
    and the jump size :math:`\ln(1+k) \sim N(\ln(1+\bar{k}) - \frac{\delta^2}{2},
    \delta^2)`.

    Parameters
    ----------
    risk_free_rate_ts : :class:`HandleYieldTermStructure`
        Risk-free rate term structure.
    dividend_ts : :class:`HandleYieldTermStructure`
        Dividend yield term structure.
    s0 : :class:`~quantlib.quote.Quote`
        Initial asset price.
    v0 : float
        Initial variance.
    kappa : float
        Mean-reversion speed of variance.
    theta : float
        Long-run variance.
    sigma : float
        Volatility of variance (vol-of-vol).
    rho : float
        Correlation between asset and variance.
    lambda_ : float
        Jump intensity (average number of jumps per year).
    nu : float
        Average jump size (log-normal).
    delta : float
        Standard deviation of jump size.
    d : Discretization
        Discretization scheme for the variance process.
    """

    def __init__(self,
       HandleYieldTermStructure risk_free_rate_ts=HandleYieldTermStructure(),
       HandleYieldTermStructure dividend_ts=HandleYieldTermStructure(),
       Quote s0=SimpleQuote(),
       Real v0=0,
       Real kappa=0,
       Real theta=0,
       Real sigma=0,
       Real rho=0,
       Real lambda_=0,
       Real nu=0,
       Real delta=0,
       Discretization d=FullTruncation):

        self._thisptr = shared_ptr[_sp.StochasticProcess](
            new QlBatesProcess(
                risk_free_rate_ts.handle(),
                dividend_ts.handle(),
                s0.handle(),
                v0, kappa, theta, sigma, rho,
                lambda_, nu, delta, d))

    def __str__(self):
        return 'Bates process\nv0: %f kappa: %f theta: %f sigma: %f\nrho: %f lambda: %f nu: %f delta: %f' % \
          (self.v0, self.kappa, self.theta, self.sigma,
           self.rho, self.Lambda, self.nu, self.delta)

    property Lambda:
        """Returns the jump intensity (average number of jumps per year).

        Returns
        -------
        float
        """
        def __get__(self):
            return (<QlBatesProcess*> self._thisptr.get()).Lambda()

    property nu:
        """Returns the average jump size.

        Returns
        -------
        float
        """
        def __get__(self):
            return (<QlBatesProcess*> self._thisptr.get()).nu()

    property delta:
        """Returns the standard deviation of the jump size.

        Returns
        -------
        float
        """
        def __get__(self):
            return (<QlBatesProcess*> self._thisptr.get()).delta()
