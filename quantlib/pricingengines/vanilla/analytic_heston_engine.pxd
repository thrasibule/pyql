from quantlib.pricingengines.engine cimport PricingEngine
from ._analytic_heston_engine cimport AnalyticHestonEngine as AHE

cdef class AnalyticHestonEngine(PricingEngine):
    pass

cdef class Integration:
    cdef AHE.Integration* itg

cdef extern from "ql/pricingengines/vanilla/analytichestonengine.hpp" \
    namespace "QuantLib::AnalyticHestonEngine":
     cpdef enum ComplexLogFormula:
         """Complex log formula for the Heston characteristic function.

         =======================  ==============================================
         Value                    Description
         =======================  ==============================================
         Gatheral                 Original Gatheral form
         BranchCorrection         Branch correction form
         AndersenPiterbarg        Andersen-Piterbarg control variate
         AndersenPiterbargOptCV   Improved Andersen-Piterbarg control variate
         AsymptoticChF            Asymptotic expansion control variate
         OptimalCV                Best control variate selected automatically
         =======================  ==============================================
         """
         Gatheral
         BranchCorrection
         AndersenPiterbarg
         AndersenPiterbargOptCV
         AsymptoticChF
         OptimalCV
