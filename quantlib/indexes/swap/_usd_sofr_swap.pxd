from quantlib.indexes._swap_index cimport OvernightIndexedSwapIndex
from quantlib.time._date cimport Period
from quantlib.handle cimport Handle
from quantlib.termstructures._yield_term_structure cimport YieldTermStructure

cdef extern from 'ql/indexes/swap/usdsofrswap.hpp' namespace 'QuantLib' nogil:
    cdef cppclass UsdSofrSwapIceFix(OvernightIndexedSwapIndex):
        UsdSofrSwapIceFix(const Period& tenor,
                          const Handle[YieldTermStructure]& h) #= Handle[YieldTermStructure]())
