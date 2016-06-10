#from .unittest_tools import unittest
import unittest

from quantlib.time.date import Date, Period, Days
import quantlib.cashflow as cf
from datetime import date
import numpy as np

class TestQuantLibDate(unittest.TestCase):

    def test_simple_cashflow(self):

        cf_date = Date(1, 7, 2030)
        cf_amount = 100.0

        test_cf = cf.SimpleCashFlow(cf_amount, cf_date)

        self.assertEqual(test_cf.amount, cf_amount)
        self.assertEqual(test_cf.date, cf_date)

    def test_leg(self):

        cf_date = Date(1, 7, 2030)
        pydate = date(2030, 7, 1)
        cf_amount = 100.0

        leg = ((cf_amount, cf_date),)

        test_leg = cf.SimpleLeg(leg)
        self.assertEqual(test_leg.size, 1)
        self.assertEqual(test_leg.items, [(100.0, pydate)])

    def test_toarray(self):

        sched = [Date(1, 1, 2000) + Period(i, Days) for i in range(100)]
        amounts = np.random.randn(100).tolist()

        test_leg = cf.SimpleLeg(zip(amounts, sched))
        a, dates = test_leg.toarray()

        np_sched = np.array([int(d)-25569 for d in sched]).view('M8[D]')
        np.testing.assert_array_equal(sched, np_sched)
        np.testing.assert_array_equal(amounts, a)

if __name__ == "__main__":
    unittest.main()
