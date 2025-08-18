include '../../types.pxi'
from quantlib.pricingengines._pricing_engine cimport PricingEngine
from quantlib.handle cimport Handle
from quantlib.termstructures._yield_term_structure cimport YieldTermStructure
from quantlib.termstructures.volatility.swaption._swaption_vol_structure \
    cimport SwaptionVolatilityStructure
from quantlib.time._date cimport Date
from quantlib.time._daycounter cimport DayCounter
from quantlib._quote cimport Quote

cdef extern from 'ql/pricingengines/swaption/blackswaptionengine.hpp' namespace 'QuantLib::detail':
    cdef cppclass BlackStyleSwaptionEngine[T](PricingEngine):
        BlackStyleSwaptionEngine()
        enum CashAnnuityModel:
            SwapRate
            DiscountCurve
    cdef struct Black76Spec:
        pass

    cdef struct BachelierSpec:
        pass

cdef extern from 'ql/pricingengines/swaption/blackswaptionengine.hpp' namespace 'QuantLib':
    cdef cppclass BlackSwaptionEngine(BlackStyleSwaptionEngine[Black76Spec]):
        BlackSwaptionEngine(const Handle[YieldTermStructure]& discountCurve,
                            Volatility vol,
                            const DayCounter& dc, #=Actual365Fixed(),
                            Real displacement, #= 0.0,
                            BlackSwaptionEngine.CashAnnuityModel model, # = DiscountCurve)
                            Date settlementDate, # = Date()
                            Date npvDate) # = Date()
        BlackSwaptionEngine(const Handle[YieldTermStructure]& discountCurve,
                            const Handle[Quote]& vol,
                            const DayCounter& dc,# = Actual365Fixed(),
                            Real displacement, #= 0.0,
                            BlackSwaptionEngine.CashAnnuityModel model, # = DiscountCurve)
                            Date settlementDate, # = Date()
                            Date npvDate) # = Date()
        BlackSwaptionEngine(const Handle[YieldTermStructure]& discountCurve,
                            const Handle[SwaptionVolatilityStructure]& vol,
                            BlackSwaptionEngine.CashAnnuityModel model, # = DiscountCurve)
                            Date settlementDate, # = Date()
                            Date npvDate) except + # = Date()

    cdef cppclass BachelierSwaptionEngine(BlackStyleSwaptionEngine[BachelierSpec]):
        BachelierSwaptionEngine(const Handle[YieldTermStructure]& discountCurve,
                                Volatility vol,
                                const DayCounter& dc,# = Actual365Fixed(),
                                BachelierSwaptionEngine.CashAnnuityModel model, # = DiscountCurve);
                                Date settlementDate, # = Date()
                                Date npvDate) # = Date()
        BachelierSwaptionEngine(const Handle[YieldTermStructure]& discountCurve,
                                const Handle[Quote]& vol,
                                const DayCounter& dc,# = Actual365Fixed(),
                                BachelierSwaptionEngine.CashAnnuityModel model, # = DiscountCurve);
                                Date settlementDate, # = Date()
                                Date npvDate) # = Date()
        BachelierSwaptionEngine(const Handle[YieldTermStructure]& discountCurve,
                                const Handle[SwaptionVolatilityStructure]& vol,
                                BachelierSwaptionEngine.CashAnnuityModel model, # = DiscountCurve);
                                Date settlementDate, # = Date()
                                Date npvDate) except + # = Date()
