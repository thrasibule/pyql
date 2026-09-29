import unittest

from quantlib.cashflows.rateaveraging import RateAveraging
from quantlib.experimental.termstructures.basisswapratehelpers import (
    OvernightOvernightBasisSwapRateHelper)
from quantlib.indexes.api import FedFunds, Sofr
from quantlib.instruments.swap import Swap
from quantlib.math.interpolation import LogLinear
from quantlib.quotes import SimpleQuote
from quantlib.settings import Settings
from quantlib.termstructures.yields.api import (
    BootstrapTrait, FlatForward, HandleYieldTermStructure, PiecewiseYieldCurve)
from quantlib.time.api import (
    Actual365Fixed, Date, Following, May, Period, UnitedStates, Years, Months)
from quantlib.time.calendars.united_states import Market


class OvernightOvernightBasisSwapRateHelperTestCase(unittest.TestCase):

    def setUp(self):
        self.today = Date(20, May, 2025)
        Settings().evaluation_date = self.today
        self.calendar = UnitedStates(Market.FederalReserve)
        self.sofr_ts = FlatForward(self.today, 0.04, Actual365Fixed())
        self.sofr_curve = HandleYieldTermStructure(self.sofr_ts)
        self.sofr = Sofr(self.sofr_curve)
        self.tenors = [Period(6, Months), Period(1, Years), Period(2, Years),
                       Period(5, Years), Period(10, Years)]

    def make_helpers(self, basis, **kwargs):
        # pays FedFunds + basis, receives SOFR; FedFunds curve is bootstrapped
        return [
            OvernightOvernightBasisSwapRateHelper(
                SimpleQuote(basis), tenor, 2, self.calendar, Following, False,
                FedFunds(), self.sofr, self.sofr_curve,
                bootstrap_base_curve=True, **kwargs)
            for tenor in self.tenors
        ]

    def bootstrap(self, helpers):
        return PiecewiseYieldCurve[BootstrapTrait.Discount, LogLinear](
            0, self.calendar, helpers, Actual365Fixed())

    def test_create(self):
        helper, *_ = self.make_helpers(0.0005)
        self.assertEqual(helper.quote.value, 0.0005)
        self.assertEqual(helper.earliest_date,
                         self.calendar.advance(self.today, 2, 0))
        self.assertIsInstance(helper.swap(), Swap)

    def test_bootstrap_reprices_quotes(self):
        for averaging in (RateAveraging.Compound, RateAveraging.Simple):
            with self.subTest(averaging=averaging):
                helpers = self.make_helpers(
                    -0.0003, base_averaging_method=averaging)
                ff_curve = self.bootstrap(helpers)
                ff_curve.nodes  # force the bootstrap
                for h in helpers:
                    self.assertAlmostEqual(h.implied_quote, h.quote.value, 10)

    def test_zero_basis_matches_sofr(self):
        ff_curve = self.bootstrap(self.make_helpers(0.0))
        for years in (1, 3, 7):
            d = self.today + Period(years, Years)
            self.assertAlmostEqual(ff_curve.discount(d),
                                   self.sofr_ts.discount(d), 5)

    def test_positive_basis_lowers_fedfunds(self):
        # paying FF + basis against SOFR: a positive basis means FF < SOFR
        ff_curve = self.bootstrap(self.make_helpers(0.001))
        d = self.today + Period(5, Years)
        self.assertGreater(ff_curve.discount(d), self.sofr_ts.discount(d))


if __name__ == '__main__':
    unittest.main()
