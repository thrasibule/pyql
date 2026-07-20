include 'types.pxi'

cdef class StochasticProcess:
    """Multi-dimensional stochastic process.

    This class describes a stochastic process governed by:

    .. math::
        d\mathrm{x}_t = \mu(t, x_t)\mathrm{d}t
                       + \sigma(t, \mathrm{x}_t) \cdot d\mathrm{W}_t.

    This is an abstract base class. Concrete implementations include
    :class:`~quantlib.processes.black_scholes_process.BlackScholesMertonProcess`,
    :class:`~quantlib.processes.heston_process.HestonProcess`,
    and :class:`~quantlib.processes.hullwhite_process.HullWhiteProcess`.
    """

    def size(self):
        """Returns the number of dimensions of the stochastic process.

        Returns
        -------
        int
        """
        return self._thisptr.get().size()

    def factors(self):
        """Returns the number of independent factors of the process.

        Returns
        -------
        int
        """
        return self._thisptr.get().factors()

cdef class StochasticProcess1D(StochasticProcess):
    """1-dimensional stochastic process.

    This class describes a stochastic process governed by:

    .. math::
        dx_t = \mu(t, x_t)dt + \sigma(t, x_t)dW_t.

    This is the 1-D specialization of
    :class:`~quantlib.stochastic_process.StochasticProcess`.
    """

    def drift(self, Time t, Real x):
        """Returns the drift part of the equation.

        That is, :math:`\mu(t, x_t)`.

        Parameters
        ----------
        t : float
            Time.
        x : float
            State variable value.

        Returns
        -------
        float
        """
        return _get_StochasticProcess1D(self).drift(t, x)

    def diffusion(self, Time t, Real x):
        """Returns the diffusion part of the equation.

        That is, :math:`\sigma(t, x_t)`.

        Parameters
        ----------
        t : float
            Time.
        x : float
            State variable value.

        Returns
        -------
        float
        """
        return _get_StochasticProcess1D(self).diffusion(t, x)

    def expectation(self, Time t0, Real x0, Time dt):
        """Returns the expectation of the process after a time interval.

        .. math::
            E(x_{t_0 + \Delta t} | x_{t_0} = x_0)

        This method can be overridden in derived classes which want to
        hard-code a particular discretization.

        Parameters
        ----------
        t0 : float
            Initial time.
        x0 : float
            Initial value of the state variable.
        dt : float
            Time interval.

        Returns
        -------
        float
        """
        return _get_StochasticProcess1D(self).expectation(t0, x0, dt)

    def std_deviation(self, Time t0, Real x0, Time dt):
        """Returns the standard deviation of the process after a time
        interval.

        .. math::
            S(x_{t_0 + \Delta t} | x_{t_0} = x_0)

        This method can be overridden in derived classes which want to
        hard-code a particular discretization.

        Parameters
        ----------
        t0 : float
            Initial time.
        x0 : float
            Initial value of the state variable.
        dt : float
            Time interval.

        Returns
        -------
        float
        """
        return _get_StochasticProcess1D(self).stdDeviation(t0, x0, dt)

    def variance(self, Time t0, Real x0, Time dt):
        """Returns the variance of the process after a time interval.

        .. math::
            V(x_{t_0 + \Delta t} | x_{t_0} = x_0)

        This method can be overridden in derived classes which want to
        hard-code a particular discretization.

        Parameters
        ----------
        t0 : float
            Initial time.
        x0 : float
            Initial value of the state variable.
        dt : float
            Time interval.

        Returns
        -------
        float
        """
        return _get_StochasticProcess1D(self).stdDeviation(t0, x0, dt)

    @property
    def x0(self):
        """Returns the initial value of the state variable.

        Returns
        -------
        float
        """
        return _get_StochasticProcess1D(self).x0()
