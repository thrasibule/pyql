import unittest
from quantlib.cashflows.api import OvernightIndexedCoupon
from quantlib.time.date import Date, October, November, December, January, March
from quantlib.settings import Settings
from quantlib.termstructures.yields.api import RelinkableHandleYieldTermStructure, FlatForward
from quantlib.time.api import Actual360
from quantlib.indexes.api import Sofr
from .utilities import flat_rate

class TestOvernightIndexedCoupon(unittest.TestCase):

    def setUp(self):
        self.today = Date(23, November, 2021)
        Settings().evaluation_date = self.today
        self.forecast_curve = RelinkableHandleYieldTermStructure()
        self.notional = 10_000
        self.sofr = Sofr(self.forecast_curve)

        self.dates = [
            Date(18, October, 2021), Date(19, October, 2021), Date(20, October, 2021),
            Date(21, October, 2021), Date(22, October, 2021), Date(25, October, 2021),
            Date(26, October, 2021), Date(27, October, 2021), Date(28, October, 2021),
            Date(29, October, 2021), Date(1, November, 2021), Date(2, November, 2021),
            Date(3, November, 2021), Date(4, November, 2021), Date(5, November, 2021),
            Date(8, November, 2021), Date(9, November, 2021), Date(10, November, 2021),
            Date(12, November, 2021), Date(15, November, 2021), Date(16, November, 2021),
            Date(17, November, 2021), Date(18, November, 2021), Date(19, November, 2021),
            Date(22, November, 2021)
        ]
        self.past_rates = [
            0.0008, 0.0009, 0.0008,
            0.0010, 0.0012, 0.0011,
            0.0013, 0.0012, 0.0012,
            0.0008, 0.0009, 0.0010,
            0.0011, 0.0014, 0.0013,
            0.0011, 0.0009, 0.0008,
            0.0007, 0.0008, 0.0008,
            0.0007, 0.0009, 0.0010,
            0.0009
        ]
        self.sofr.add_fixings(self.dates, self.past_rates)

    def make_coupon(self, start_date, end_date):
        return OvernightIndexedCoupon(end_date, self.notional, start_date, end_date, self.sofr)

    def test_past_coupon_rate(self):
        """Testing rate for past overnight-indexed coupon"""
        past_coupon = self.make_coupon(Date(18, October, 2021),
                                       Date(18, November, 2021))
        expected_rate = 0.000987136104
        expected_amount = self.notional * expected_rate * 31.0/360
        self.assertAlmostEqual(past_coupon.rate, expected_rate)
        self.assertAlmostEqual(past_coupon.amount, expected_amount)

    def test_current_coupon_rate(self):
        """Testing rate for current overnight-indexed coupon"""
        self.forecast_curve.link_to(flat_rate(0.0010, Actual360()))
        current_coupon = self.make_coupon(Date(10, November, 2021),
                                          Date(10, December, 2021))
        expected_rate = 0.000926701551
        expected_amount = self.notional * expected_rate * 30.0/360
        self.assertAlmostEqual(current_coupon.rate, expected_rate)
        self.assertAlmostEqual(current_coupon.amount, expected_amount)

        self.sofr.add_fixing(Date(23, November, 2021), 0.0007)
        expected_rate = 0.000916700760
        expected_amount = self.notional * expected_rate * 30.0/360
        self.assertAlmostEqual(current_coupon.rate, expected_rate)
        self.assertAlmostEqual(current_coupon.amount, expected_amount)
        self.sofr.clear_fixings()
        self.sofr.add_fixings(self.dates, self.past_rates)

    def test_future_coupon_rate(self):
        """Testing rate for future overnight-indexed coupon"""
        self.forecast_curve.link_to(flat_rate(0.0010, Actual360()))
        future_coupon = self.make_coupon(Date(10, December, 2021),
                                          Date(10, January, 2022))
        expected_rate = 0.001000043057
        expected_amount = self.notional * expected_rate * 31.0/360
        self.assertAlmostEqual(future_coupon.rate, expected_rate)
        self.assertAlmostEqual(future_coupon.amount, expected_amount)


    def test_rate_when_today_is_holiday(self):
        """Testing rate for overnight-indexed coupon when today is a holiday"""
        with Settings() as s:
            s.evaluation_date = Date(20, November, 2021)
            self.forecast_curve.link_to(flat_rate(0.0010, Actual360()))
            coupon = self.make_coupon(Date(10, November, 2021),
                                      Date(10, December, 2021))
            expected_rate = 0.000930035180
            expected_amount = self.notional * expected_rate * 30.0/360
            self.assertAlmostEqual(coupon.rate, expected_rate)
            self.assertAlmostEqual(coupon.amount, expected_amount)

    def test_accrued_amount_in_the_past(self):
        """Testing accrued amount in the past for overnight-indexed coupon"""
        coupon = self.make_coupon(Date(18, October, 2021),
                                  Date(18, January, 2022))

        expected_amount = self.notional * 0.000987136104 * 31.0/360
        self.assertAlmostEqual(coupon.accrued_amount(Date(18, November, 2021)), expected_amount)

    def test_accrued_amount_spanning_today(self):
        """Testing accrued amount spanning today for current overnight-indexed coupon"""
        self.forecast_curve.link_to(flat_rate(0.0010, Actual360()))
        coupon = self.make_coupon(Date(10, November, 2021),
                                  Date(10, January, 2022))
        expected_amount = self.notional * 0.000926701551 * 30.0/360
        self.assertAlmostEqual(coupon.accrued_amount(Date(10, December, 2021)), expected_amount)
        self.sofr.add_fixing(Date(23, November, 2021), 0.0007)
        expected_amount = self.notional * 0.000916700760 * 30.0/360
        self.assertAlmostEqual(coupon.accrued_amount(Date(10, December, 2021)), expected_amount)
        self.sofr.clear_fixings()
        self.sofr.add_fixings(self.dates, self.past_rates)

    def test_accrued_amount_in_the_futures(self):
        """Testing accrued amount in the future for overnight-indexed coupon"""
        self.forecast_curve.link_to(flat_rate(0.0010, Actual360()))
        coupon = self.make_coupon(Date(10, December, 2021),
                                  Date(10, March, 2022))

        accrual_date = Date(10, January, 2022)
        expected_rate = 0.001000043057
        expected_amount = self.notional * expected_rate * 31.0/360
        self.assertAlmostEqual(coupon.accrued_amount(accrual_date), expected_amount)


class TestFlooredOvernightLeg(unittest.TestCase):

    def test_floors_at_zero_volatility(self):
        """Floored compounded coupons at zero volatility are the larger of
        the coupon and the floor"""
        from quantlib.cashflows.overnight_indexed_coupon import OvernightLeg
        from quantlib.cashflows.overnight_indexed_coupon_pricer import (
            BlackCompoundingOvernightIndexedCouponPricer)
        from quantlib.handle import HandleOptionletVolatilityStructure
        from quantlib.termstructures.volatility.optionlet.optionlet_volatility_structure import (
            ConstantOptionletVolatility)
        from quantlib.termstructures.volatility.volatilitytype import VolatilityType
        from quantlib.termstructures.yields.api import HandleYieldTermStructure
        from quantlib.time.api import (Actual365Fixed, DateGeneration, Following, Months,
                                       Period, Schedule, Unadjusted, UnitedStates)
        from quantlib.time.calendars.united_states import Market

        today = Date(23, November, 2021)
        Settings().evaluation_date = today
        sofr = Sofr(HandleYieldTermStructure(flat_rate(0.02, Actual360())))
        cal = UnitedStates(Market.GovernmentBond)
        schedule = Schedule.from_rule(today, Date(23, November, 2023), Period(3, Months), cal,
                                      Following, Unadjusted, DateGeneration.Forward, False)
        vol = ConstantOptionletVolatility(0, cal, Following, 0.0, Actual365Fixed(),
                                          VolatilityType.Normal)
        pricer = BlackCompoundingOvernightIndexedCouponPricer(
            HandleOptionletVolatilityStructure(vol))
        spread = 0.01
        plain = OvernightLeg(schedule, sofr).with_notionals(1.0).with_spreads(spread)()
        for floor in (0.05, 0.0):  # above, and below the spread
            floored = (OvernightLeg(schedule, sofr).with_notionals(1.0).with_spreads(spread)
                       .with_floors(floor).with_coupon_pricer(pricer)())
            for (a, d), (b, _), start, end in zip(plain.items(), floored.items(),
                                                   schedule.dates()[:-1], schedule.dates()[1:]):
                accrual = Actual360().year_fraction(start, end)
                self.assertAlmostEqual(b, max(a, floor * accrual), places=12)

    def test_constant_optionlet_volatility_type(self):
        """ConstantOptionletVolatility is shifted lognormal by default, which
        can't price a floor below the spread (a negative strike on the
        index), unlike normal volatility"""
        from quantlib.cashflows.overnight_indexed_coupon import OvernightLeg
        from quantlib.cashflows.overnight_indexed_coupon_pricer import (
            BlackCompoundingOvernightIndexedCouponPricer)
        from quantlib.handle import HandleOptionletVolatilityStructure
        from quantlib.termstructures.volatility.optionlet.optionlet_volatility_structure import (
            ConstantOptionletVolatility)
        from quantlib.termstructures.yields.api import HandleYieldTermStructure
        from quantlib.time.api import (Actual365Fixed, DateGeneration, Following, Months,
                                       Period, Schedule, Unadjusted, UnitedStates)
        from quantlib.time.calendars.united_states import Market

        today = Date(23, November, 2021)
        Settings().evaluation_date = today
        sofr = Sofr(HandleYieldTermStructure(flat_rate(0.02, Actual360())))
        cal = UnitedStates(Market.GovernmentBond)
        schedule = Schedule.from_rule(today, Date(23, November, 2022), Period(3, Months), cal,
                                      Following, Unadjusted, DateGeneration.Forward, False)
        vol = ConstantOptionletVolatility(0, cal, Following, 0.0, Actual365Fixed())
        pricer = BlackCompoundingOvernightIndexedCouponPricer(
            HandleOptionletVolatilityStructure(vol))
        leg = (OvernightLeg(schedule, sofr).with_notionals(1.0).with_spreads(0.01)
               .with_floors(0.0).with_coupon_pricer(pricer)())
        with self.assertRaises(RuntimeError):
            leg.items()


class TestOptionletVolatilityType(unittest.TestCase):

    def test_volatility_type(self):
        """ConstantOptionletVolatility is shifted lognormal by default"""
        from quantlib.termstructures.volatility.optionlet.optionlet_volatility_structure import (
            ConstantOptionletVolatility)
        from quantlib.termstructures.volatility.volatilitytype import VolatilityType
        from quantlib.time.api import Actual365Fixed, Following, TARGET
        lognormal = ConstantOptionletVolatility(0, TARGET(), Following, 0.2, Actual365Fixed())
        shifted = ConstantOptionletVolatility(0, TARGET(), Following, 0.2, Actual365Fixed(),
                                              VolatilityType.ShiftedLognormal, 0.01)
        normal = ConstantOptionletVolatility(0, TARGET(), Following, 0.01, Actual365Fixed(),
                                             VolatilityType.Normal)
        self.assertEqual(lognormal.volatility_type, VolatilityType.ShiftedLognormal)
        self.assertEqual(lognormal.displacement, 0.0)
        self.assertEqual(shifted.displacement, 0.01)
        self.assertEqual(normal.volatility_type, VolatilityType.Normal)
