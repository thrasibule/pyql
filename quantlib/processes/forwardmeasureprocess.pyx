from quantlib.types cimport Time
from . cimport _forwardmeasureprocess as _fmp

cdef class ForwardMeasureProcess(StochasticProcess):
    """Multi-dimensional forward measure stochastic process.

    This process allows specifying a forward measure time, which
    changes the measure under which expectations are computed.
    """

    @property
    def forward_measure_time(self):
        """Returns the forward measure time.

        Returns
        -------
        float
        """
        return (<_fmp.ForwardMeasureProcess*>self._thisptr.get()).getForwardMeasureTime()

    @forward_measure_time.setter
    def forward_measure_time(self, Time t):
        """Sets the forward measure time.

        Parameters
        ----------
        t : float
            The forward measure time.
        """
        (<_fmp.ForwardMeasureProcess*>self._thisptr.get()).setForwardMeasureTime(t)

cdef class ForwardMeasureProcess1D(StochasticProcess1D):
    """1-dimensional forward measure stochastic process.

    This process allows specifying a forward measure time, which
    changes the measure under which expectations are computed.
    """

    @property
    def forward_measure_time(self):
        """Returns the forward measure time.

        Returns
        -------
        float
        """
        return (<_fmp.ForwardMeasureProcess1D*>self._thisptr.get()).getForwardMeasureTime()

    @forward_measure_time.setter
    def forward_measure_time(self, Time t):
        """Sets the forward measure time.

        Parameters
        ----------
        t : float
            The forward measure time.
        """
        (<_fmp.ForwardMeasureProcess1D*>self._thisptr.get()).setForwardMeasureTime(t)
