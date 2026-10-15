from quantlib.handle cimport HandleYieldTermStructure
from . cimport _estr as _es
from ... cimport _index as _in

cdef class Estr(OvernightIndex):
    """ ESTR (Euro Short-Term Rate), the euro overnight rate fixed by the ECB.

    An overnight index with the ECB conventions: 0 fixing days, TARGET
    calendar and an Actual/360 day counter.

    Parameters
    ----------
    yts : HandleYieldTermStructure
        The term structure used to forecast future fixings.
    """
    def __init__(self, HandleYieldTermStructure yts=HandleYieldTermStructure()):
        self._thisptr.reset(new _es.Estr(yts.handle()))
