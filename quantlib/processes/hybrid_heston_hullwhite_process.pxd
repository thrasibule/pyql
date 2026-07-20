from quantlib.stochastic_process cimport StochasticProcess

cdef extern from "ql/processes/hybridhestonhullwhiteprocess.hpp" namespace "QuantLib::HybridHestonHullWhiteProcess" nogil:
    cpdef enum class Discretization:
        """Discretization scheme for the hybrid Heston-Hull-White process.

        - **Euler**:       Standard Euler discretization
        - **BSMHullWhite**: BSM-Hull-White discretization
        """
        Euler
        BSMHullWhite

cdef class HybridHestonHullWhiteProcess(StochasticProcess):
    pass
