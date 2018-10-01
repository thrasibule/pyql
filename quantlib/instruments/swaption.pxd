from ._swaption cimport Settlement
from .instrument cimport Instrument

cpdef enum SettlementType:
    Physical
    Cash

cpdef enum SettlementMethod:
    PhysicalOTC
    PhysicalCleared
    CollateralizedCashPrice
    ParYieldCurve

cdef class Swaption(Instrument):
    pass
