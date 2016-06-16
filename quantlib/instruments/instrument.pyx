from cython.operator cimport dereference as deref

from quantlib.handle cimport shared_ptr
from quantlib.pricingengines.engine cimport PricingEngine

cimport quantlib.pricingengines._pricing_engine as _pe
cimport _instrument

cdef class Instrument:

    def __cinit__(self):
        self._has_pricing_engine = False

    def set_pricing_engine(self, PricingEngine engine):
        '''Sets the pricing engine.

        '''
        self._thisptr.get().setPricingEngine(engine._thisptr)

        self._has_pricing_engine = True

    property net_present_value:
        """ Instrument net present value. """
        def __get__(self):
            if self._has_pricing_engine:
                return self._thisptr.get().NPV()

    property npv:
        """ Shortcut to the net_present_value property. """
        def __get__(self):
            return self.net_present_value
