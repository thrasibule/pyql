from quantlib.pricingengines.engine cimport PricingEngine
from . cimport _fdblackscholesvanillaengine as _fdbs

cdef class FdBlackScholesVanillaEngine(PricingEngine):
    pass

cpdef enum CashDividendModel:
    """Cash dividend model: Spot (dividend paid immediately) or Escrowed (dividend held in escrow)."""
    Spot = _fdbs.Spot
    Escrowed = _fdbs.Escrowed
