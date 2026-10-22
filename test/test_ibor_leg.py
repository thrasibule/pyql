import unittest

from quantlib.cashflows.coupon_pricer import BlackIborCouponPricer, set_coupon_pricer
from quantlib.cashflows.ibor_coupon import IborLeg
from quantlib.handle import HandleOptionletVolatilityStructure
from quantlib.indexes.api import Euribor6M
from quantlib.settings import Settings
from quantlib.termstructures.volatility.optionlet.optionlet_volatility_structure import (
    ConstantOptionletVolatility)
from quantlib.termstructures.volatility.volatilitytype import VolatilityType
from quantlib.termstructures.yields.api import HandleYieldTermStructure
from quantlib.time.api import (Actual360, Actual365Fixed, Date, DateGeneration, Following,
                               Months, Period, Schedule, TARGET, Unadjusted, November)

from .utilities import flat_rate


class TestIborLeg(unittest.TestCase):

    def setUp(self):
        self.today = Date(23, November, 2021)
        Settings().evaluation_date = self.today
        self.index = Euribor6M(HandleYieldTermStructure(flat_rate(0.02, Actual360())))
        start = TARGET().advance(self.today, 2, 0)
        self.schedule = Schedule.from_rule(start, Date(23, November, 2026), Period(6, Months),
                                           TARGET(), Following, Unadjusted,
                                           DateGeneration.Forward, False)

    def test_coupons(self):
        """an IborLeg of indexed coupons pays each period's forecast fixing plus
        the spread"""
        spread = 0.01
        leg = (IborLeg(self.schedule, self.index).with_notionals(100.).with_spreads(spread)
               .with_indexed_coupons()())
        dates = self.schedule.dates()
        self.assertEqual(len(leg), len(dates) - 1)
        for (amount, _), start, end in zip(leg.items(), dates[:-1], dates[1:]):
            fixing = self.index.forecast_fixing(self.index.fixing_date(start))
            accrual = Actual360().year_fraction(start, end)
            self.assertAlmostEqual(amount, 100. * (fixing + spread) * accrual, places=8)

    def test_floors_at_zero_volatility(self):
        """floored coupons at zero (normal) volatility are the larger of the
        coupon and the floor"""
        spread = 0.01
        plain = IborLeg(self.schedule, self.index).with_notionals(1.).with_spreads(spread)()
        vol = ConstantOptionletVolatility(0, TARGET(), Following, 0., Actual365Fixed(),
                                          VolatilityType.Normal)
        pricer = BlackIborCouponPricer(HandleOptionletVolatilityStructure(vol))
        dates = self.schedule.dates()
        for floor in (0.05, 0.0):
            floored = (IborLeg(self.schedule, self.index).with_notionals(1.)
                       .with_spreads(spread).with_floors(floor)())
            set_coupon_pricer(floored, pricer)
            for (a, _), (b, _), start, end in zip(plain.items(), floored.items(),
                                                   dates[:-1], dates[1:]):
                accrual = Actual360().year_fraction(start, end)
                self.assertAlmostEqual(b, max(a, floor * accrual), places=10)

    def test_unbuilt_leg(self):
        """a leg not made from a schedule and an index can't be built"""
        with self.assertRaises(ValueError):
            IborLeg.__new__(IborLeg)()
