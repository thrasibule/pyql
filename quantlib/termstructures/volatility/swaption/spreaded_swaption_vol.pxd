from . cimport _spreaded_swaption_vol as _ssv
from .swaption_vol_structure cimport SwaptionVolatilityStructure

cdef class SpreadedSwaptionVolatility(SwaptionVolatilityStructure):
    pass
