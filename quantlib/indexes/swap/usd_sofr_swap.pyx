from cython.operator cimport dereference as deref
from quantlib.time.date cimport Period
from quantlib.termstructures.yield_term_structure cimport YieldTermStructure
from quantlib.indexes.swap_index cimport OvernightIndexedSwapIndex

cimport quantlib.indexes.swap._usd_sofr_swap as _uss
cimport quantlib._index as _in

cdef class UsdSofrSwapIceFix(OvernightIndexedSwapIndex):
    def __init__(self, Period tenor, YieldTermStructure yts=YieldTermStructure()):
        self._thisptr.reset(
            new _uss.UsdSofrSwapIceFix(deref(tenor._thisptr),
                                       yts._thisptr)
        )