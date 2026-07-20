from quantlib.stochastic_process cimport StochasticProcess
from ._heston_process cimport HestonProcess as QlHestonProcess

cdef extern from "ql/processes/hestonprocess.hpp" namespace "QuantLib::HestonProcess" nogil:
    cpdef enum Discretization:
        """Discretization schemes for the Heston variance process.

        =====================================  ========================================
        Value                                  Description
        =====================================  ========================================
        PartialTruncation                      Partial truncation scheme
        FullTruncation                         Full truncation scheme
        Reflection                             Reflection scheme
        NonCentralChiSquareVariance            Non-central chi-square sampling
        QuadraticExponential                   Quadratic-exponential scheme
        QuadraticExponentialMartingale         Quadratic-exponential with martingale
                                               correction
        BroadieKayaExactSchemeLobatto          Broadie-Kaya exact scheme (Lobatto)
        BroadieKayaExactSchemeLaguerre         Broadie-Kaya exact scheme (Laguerre)
        BroadieKayaExactSchemeTrapezoidal      Broadie-Kaya exact scheme (Trapezoidal)
        =====================================  ========================================
        """
        PartialTruncation
        FullTruncation
        Reflection
        NonCentralChiSquareVariance
        QuadraticExponential
        QuadraticExponentialMartingale
        BroadieKayaExactSchemeLobatto
        BroadieKayaExactSchemeLaguerre
        BroadieKayaExactSchemeTrapezoidal

cdef class HestonProcess(StochasticProcess):
    pass
