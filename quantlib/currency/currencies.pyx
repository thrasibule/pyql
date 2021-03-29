"""
Contains all the country specific currency implementations.
"""

from . cimport _currency as _cu

from .currency cimport Currency

cdef class USDCurrency(Currency):
    """U.S. dollar"""
    def __cinit__(self):
        """ test test2 test3"""
        self._thisptr = <_cu.Currency*> new _cu.USDCurrency()

cdef class EURCurrency(Currency):
    def __cinit__(self):
        self._thisptr = <_cu.Currency*> new _cu.EURCurrency()

cdef class GBPCurrency(Currency):
    def __cinit__(self):
        self._thisptr = <_cu.Currency*> new _cu.GBPCurrency()

cdef class JPYCurrency(Currency):
    def __cinit__(self):
        self._thisptr = <_cu.Currency*> new _cu.JPYCurrency()

cdef class CHFCurrency(Currency):
    def __cinit__(self):
        self._thisptr = <_cu.Currency*> new _cu.CHFCurrency()

cdef class AUDCurrency(Currency):
    def __cinit__(self):
        self._thisptr = <_cu.Currency*> new _cu.AUDCurrency()

cdef class DKKCurrency(Currency):
    def __cinit__(self):
        self._thisptr = <_cu.Currency*> new _cu.DKKCurrency()

cdef class INRCurrency(Currency):
    def __cinit__(self):
        self._thisptr = <_cu.Currency*> new _cu.INRCurrency()

cdef class HKDCurrency(Currency):
    def __cinit__(self):
        self._thisptr = <_cu.Currency*> new _cu.HKDCurrency()

cdef class NOKCurrency(Currency):
    def __cinit__(self):
        self._thisptr = <_cu.Currency*> new _cu.NOKCurrency()

cdef class NZDCurrency(Currency):
    def __cinit__(self):
        self._thisptr = <_cu.Currency*> new _cu.NZDCurrency()

cdef class PLNCurrency(Currency):
    def __cinit__(self):
        self._thisptr = <_cu.Currency*> new _cu.PLNCurrency()

cdef class SEKCurrency(Currency):
    def __cinit__(self):
        self._thisptr = <_cu.Currency*> new _cu.SEKCurrency()

cdef class SGDCurrency(Currency):
    def __cinit__(self):
        self._thisptr = <_cu.Currency*> new _cu.SGDCurrency()

cdef class ZARCurrency(Currency):
    def __cinit__(self):
        self._thisptr = <_cu.Currency*> new _cu.ZARCurrency()
