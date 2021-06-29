from quantlib.types cimport Natural, Real
from cython.operator cimport dereference as deref
from libcpp.vector cimport vector

from quantlib.handle cimport shared_ptr

from . cimport _rate_helpers as _rh
from .. cimport _yield_term_structure as _yts

from .rate_helpers cimport RateHelper
from quantlib.time.date cimport Date, date_from_qldate
cimport quantlib.time._date as _date
from quantlib.time.daycounter cimport DayCounter
from quantlib.time.calendar cimport Calendar
from quantlib.math.interpolation cimport Linear, LogLinear, BackwardFlat
from .bootstraptraits import BootstrapTrait
from itertools import product

_registry = {}

for T, I in product(BootstrapTrait, [Linear, LogLinear, BackwardFlat]):
    _registry[T,I] = globals()[f"{T.name}{I.__name__}PiecewiseYieldCurve"]


cdef class PiecewiseYieldCurve:
    """A piecewise yield curve.

    Parameters
    ----------
    trait : str
        the kind of curve. Must be either 'discount', 'forward' or 'zero'
    interpolator : str
        the kind of interpolator. Must be either 'loglinear', 'linear' or
        'spline'
    settlement_date : quantlib.time.date.Date
        The settlement date
    helpers : list of quantlib.termstructures.rate_helpers.RateHelper
        a list of rate helpers used to create the curve
    day_counter : quantlib.time.day_counter.DayCounter
        the day counter used by this curve
    tolerance : double (default 1e-12)
        the tolerance

    """

    def __class_getitem__(cls, tuple tup):
        return _registry[tup]
cdef class DiscountLinearPiecewiseYieldCurve(YieldTermStructure):
    def __init__(self, Natural settlement_days, Calendar calendar not None,
                 list helpers, DayCounter daycounter not None,
                 Linear i=Linear(),
                 Real accuracy = 1e-12):


        if len(helpers) == 0:
            raise ValueError('Cannot initialize curve with no helpers')

        # convert Python list to std::vector
        cdef vector[shared_ptr[_rh.RateHelper]] instruments

        for helper in helpers:
            instruments.push_back((<RateHelper?> helper)._thisptr)

        self._curve = new _pyc.PiecewiseYieldCurve[trait.Discount, intpl.Linear](
            settlement_days, deref(calendar._thisptr), instruments,
            deref(daycounter._thisptr),
            i._thisptr,
            _pyc.PiecewiseYieldCurve[trait.Discount, intpl.Linear].bootstrap_type(accuracy)
        )
        self._thisptr.linkTo(shared_ptr[_yts.YieldTermStructure](self._curve))

    @classmethod
    def from_reference_date(cls, Date reference_date, list helpers,
                            DayCounter daycounter not None, Linear i=Linear(),
                            Real accuracy=1e-12):

        if len(helpers) == 0:
            raise ValueError('Cannot initialize curve with no helpers')

        # convert Python list to std::vector
        cdef vector[shared_ptr[_rh.RateHelper]] instruments
        cdef DiscountLinearPiecewiseYieldCurve instance = cls.__new__(cls)

        for helper in helpers:
            instruments.push_back((<RateHelper?> helper)._thisptr)

        instance._curve = new _pyc.PiecewiseYieldCurve[trait.Discount, intpl.Linear](
            deref(reference_date._thisptr), instruments, deref(daycounter._thisptr),
            i._thisptr,
            _pyc.PiecewiseYieldCurve[trait.Discount, intpl.Linear].bootstrap_type(accuracy)
        )
        instance._thisptr.linkTo(shared_ptr[_yts.YieldTermStructure](instance._curve))
        return instance


    @property
    def data(self):
        """list of curve data"""
        return self._curve.data()
    @property
    def times(self):
        """list of curve times"""
        return self._curve.times()

    @property
    def dates(self):
        """list of curve dates"""
        cdef vector[_date.Date] _dates = self._curve.dates()
        cdef list r  = []
        cdef _date.Date qldate
        for qldate in _dates:
            r.append(date_from_qldate(qldate))

        return r

cdef class DiscountLogLinearPiecewiseYieldCurve(YieldTermStructure):
    def __init__(self, Natural settlement_days, Calendar calendar not None,
                 list helpers, DayCounter daycounter not None,
                 LogLinear i=LogLinear(),
                 Real accuracy = 1e-12):


        if len(helpers) == 0:
            raise ValueError('Cannot initialize curve with no helpers')

        # convert Python list to std::vector
        cdef vector[shared_ptr[_rh.RateHelper]] instruments

        for helper in helpers:
            instruments.push_back((<RateHelper?> helper)._thisptr)

        self._curve = new _pyc.PiecewiseYieldCurve[trait.Discount, intpl.LogLinear](
            settlement_days, deref(calendar._thisptr), instruments,
            deref(daycounter._thisptr),
            i._thisptr,
            _pyc.PiecewiseYieldCurve[trait.Discount, intpl.LogLinear].bootstrap_type(accuracy)
        )
        self._thisptr.linkTo(shared_ptr[_yts.YieldTermStructure](self._curve))

    @classmethod
    def from_reference_date(cls, Date reference_date, list helpers,
                            DayCounter daycounter not None, LogLinear i=LogLinear(),
                            Real accuracy=1e-12):

        if len(helpers) == 0:
            raise ValueError('Cannot initialize curve with no helpers')

        # convert Python list to std::vector
        cdef vector[shared_ptr[_rh.RateHelper]] instruments
        cdef DiscountLogLinearPiecewiseYieldCurve instance = cls.__new__(cls)

        for helper in helpers:
            instruments.push_back((<RateHelper?> helper)._thisptr)

        instance._curve = new _pyc.PiecewiseYieldCurve[trait.Discount, intpl.LogLinear](
            deref(reference_date._thisptr), instruments, deref(daycounter._thisptr),
            i._thisptr,
            _pyc.PiecewiseYieldCurve[trait.Discount, intpl.LogLinear].bootstrap_type(accuracy)
        )
        instance._thisptr.linkTo(shared_ptr[_yts.YieldTermStructure](instance._curve))
        return instance


    @property
    def data(self):
        """list of curve data"""
        return self._curve.data()
    @property
    def times(self):
        """list of curve times"""
        return self._curve.times()

    @property
    def dates(self):
        """list of curve dates"""
        cdef vector[_date.Date] _dates = self._curve.dates()
        cdef list r  = []
        cdef _date.Date qldate
        for qldate in _dates:
            r.append(date_from_qldate(qldate))

        return r

cdef class DiscountBackwardFlatPiecewiseYieldCurve(YieldTermStructure):
    def __init__(self, Natural settlement_days, Calendar calendar not None,
                 list helpers, DayCounter daycounter not None,
                 BackwardFlat i=BackwardFlat(),
                 Real accuracy = 1e-12):


        if len(helpers) == 0:
            raise ValueError('Cannot initialize curve with no helpers')

        # convert Python list to std::vector
        cdef vector[shared_ptr[_rh.RateHelper]] instruments

        for helper in helpers:
            instruments.push_back((<RateHelper?> helper)._thisptr)

        self._curve = new _pyc.PiecewiseYieldCurve[trait.Discount, intpl.BackwardFlat](
            settlement_days, deref(calendar._thisptr), instruments,
            deref(daycounter._thisptr),
            i._thisptr,
            _pyc.PiecewiseYieldCurve[trait.Discount, intpl.BackwardFlat].bootstrap_type(accuracy)
        )
        self._thisptr.linkTo(shared_ptr[_yts.YieldTermStructure](self._curve))

    @classmethod
    def from_reference_date(cls, Date reference_date, list helpers,
                            DayCounter daycounter not None, BackwardFlat i=BackwardFlat(),
                            Real accuracy=1e-12):

        if len(helpers) == 0:
            raise ValueError('Cannot initialize curve with no helpers')

        # convert Python list to std::vector
        cdef vector[shared_ptr[_rh.RateHelper]] instruments
        cdef DiscountBackwardFlatPiecewiseYieldCurve instance = cls.__new__(cls)

        for helper in helpers:
            instruments.push_back((<RateHelper?> helper)._thisptr)

        instance._curve = new _pyc.PiecewiseYieldCurve[trait.Discount, intpl.BackwardFlat](
            deref(reference_date._thisptr), instruments, deref(daycounter._thisptr),
            i._thisptr,
            _pyc.PiecewiseYieldCurve[trait.Discount, intpl.BackwardFlat].bootstrap_type(accuracy)
        )
        instance._thisptr.linkTo(shared_ptr[_yts.YieldTermStructure](instance._curve))
        return instance


    @property
    def data(self):
        """list of curve data"""
        return self._curve.data()
    @property
    def times(self):
        """list of curve times"""
        return self._curve.times()

    @property
    def dates(self):
        """list of curve dates"""
        cdef vector[_date.Date] _dates = self._curve.dates()
        cdef list r  = []
        cdef _date.Date qldate
        for qldate in _dates:
            r.append(date_from_qldate(qldate))

        return r

cdef class ZeroYieldLinearPiecewiseYieldCurve(YieldTermStructure):
    def __init__(self, Natural settlement_days, Calendar calendar not None,
                 list helpers, DayCounter daycounter not None,
                 Linear i=Linear(),
                 Real accuracy = 1e-12):


        if len(helpers) == 0:
            raise ValueError('Cannot initialize curve with no helpers')

        # convert Python list to std::vector
        cdef vector[shared_ptr[_rh.RateHelper]] instruments

        for helper in helpers:
            instruments.push_back((<RateHelper?> helper)._thisptr)

        self._curve = new _pyc.PiecewiseYieldCurve[trait.ZeroYield, intpl.Linear](
            settlement_days, deref(calendar._thisptr), instruments,
            deref(daycounter._thisptr),
            i._thisptr,
            _pyc.PiecewiseYieldCurve[trait.ZeroYield, intpl.Linear].bootstrap_type(accuracy)
        )
        self._thisptr.linkTo(shared_ptr[_yts.YieldTermStructure](self._curve))

    @classmethod
    def from_reference_date(cls, Date reference_date, list helpers,
                            DayCounter daycounter not None, Linear i=Linear(),
                            Real accuracy=1e-12):

        if len(helpers) == 0:
            raise ValueError('Cannot initialize curve with no helpers')

        # convert Python list to std::vector
        cdef vector[shared_ptr[_rh.RateHelper]] instruments
        cdef ZeroYieldLinearPiecewiseYieldCurve instance = cls.__new__(cls)

        for helper in helpers:
            instruments.push_back((<RateHelper?> helper)._thisptr)

        instance._curve = new _pyc.PiecewiseYieldCurve[trait.ZeroYield, intpl.Linear](
            deref(reference_date._thisptr), instruments, deref(daycounter._thisptr),
            i._thisptr,
            _pyc.PiecewiseYieldCurve[trait.ZeroYield, intpl.Linear].bootstrap_type(accuracy)
        )
        instance._thisptr.linkTo(shared_ptr[_yts.YieldTermStructure](instance._curve))
        return instance


    @property
    def data(self):
        """list of curve data"""
        return self._curve.data()
    @property
    def times(self):
        """list of curve times"""
        return self._curve.times()

    @property
    def dates(self):
        """list of curve dates"""
        cdef vector[_date.Date] _dates = self._curve.dates()
        cdef list r  = []
        cdef _date.Date qldate
        for qldate in _dates:
            r.append(date_from_qldate(qldate))

        return r

cdef class ZeroYieldLogLinearPiecewiseYieldCurve(YieldTermStructure):
    def __init__(self, Natural settlement_days, Calendar calendar not None,
                 list helpers, DayCounter daycounter not None,
                 LogLinear i=LogLinear(),
                 Real accuracy = 1e-12):


        if len(helpers) == 0:
            raise ValueError('Cannot initialize curve with no helpers')

        # convert Python list to std::vector
        cdef vector[shared_ptr[_rh.RateHelper]] instruments

        for helper in helpers:
            instruments.push_back((<RateHelper?> helper)._thisptr)

        self._curve = new _pyc.PiecewiseYieldCurve[trait.ZeroYield, intpl.LogLinear](
            settlement_days, deref(calendar._thisptr), instruments,
            deref(daycounter._thisptr),
            i._thisptr,
            _pyc.PiecewiseYieldCurve[trait.ZeroYield, intpl.LogLinear].bootstrap_type(accuracy)
        )
        self._thisptr.linkTo(shared_ptr[_yts.YieldTermStructure](self._curve))

    @classmethod
    def from_reference_date(cls, Date reference_date, list helpers,
                            DayCounter daycounter not None, LogLinear i=LogLinear(),
                            Real accuracy=1e-12):

        if len(helpers) == 0:
            raise ValueError('Cannot initialize curve with no helpers')

        # convert Python list to std::vector
        cdef vector[shared_ptr[_rh.RateHelper]] instruments
        cdef ZeroYieldLogLinearPiecewiseYieldCurve instance = cls.__new__(cls)

        for helper in helpers:
            instruments.push_back((<RateHelper?> helper)._thisptr)

        instance._curve = new _pyc.PiecewiseYieldCurve[trait.ZeroYield, intpl.LogLinear](
            deref(reference_date._thisptr), instruments, deref(daycounter._thisptr),
            i._thisptr,
            _pyc.PiecewiseYieldCurve[trait.ZeroYield, intpl.LogLinear].bootstrap_type(accuracy)
        )
        instance._thisptr.linkTo(shared_ptr[_yts.YieldTermStructure](instance._curve))
        return instance


    @property
    def data(self):
        """list of curve data"""
        return self._curve.data()
    @property
    def times(self):
        """list of curve times"""
        return self._curve.times()

    @property
    def dates(self):
        """list of curve dates"""
        cdef vector[_date.Date] _dates = self._curve.dates()
        cdef list r  = []
        cdef _date.Date qldate
        for qldate in _dates:
            r.append(date_from_qldate(qldate))

        return r

cdef class ZeroYieldBackwardFlatPiecewiseYieldCurve(YieldTermStructure):
    def __init__(self, Natural settlement_days, Calendar calendar not None,
                 list helpers, DayCounter daycounter not None,
                 BackwardFlat i=BackwardFlat(),
                 Real accuracy = 1e-12):


        if len(helpers) == 0:
            raise ValueError('Cannot initialize curve with no helpers')

        # convert Python list to std::vector
        cdef vector[shared_ptr[_rh.RateHelper]] instruments

        for helper in helpers:
            instruments.push_back((<RateHelper?> helper)._thisptr)

        self._curve = new _pyc.PiecewiseYieldCurve[trait.ZeroYield, intpl.BackwardFlat](
            settlement_days, deref(calendar._thisptr), instruments,
            deref(daycounter._thisptr),
            i._thisptr,
            _pyc.PiecewiseYieldCurve[trait.ZeroYield, intpl.BackwardFlat].bootstrap_type(accuracy)
        )
        self._thisptr.linkTo(shared_ptr[_yts.YieldTermStructure](self._curve))

    @classmethod
    def from_reference_date(cls, Date reference_date, list helpers,
                            DayCounter daycounter not None, BackwardFlat i=BackwardFlat(),
                            Real accuracy=1e-12):

        if len(helpers) == 0:
            raise ValueError('Cannot initialize curve with no helpers')

        # convert Python list to std::vector
        cdef vector[shared_ptr[_rh.RateHelper]] instruments
        cdef ZeroYieldBackwardFlatPiecewiseYieldCurve instance = cls.__new__(cls)

        for helper in helpers:
            instruments.push_back((<RateHelper?> helper)._thisptr)

        instance._curve = new _pyc.PiecewiseYieldCurve[trait.ZeroYield, intpl.BackwardFlat](
            deref(reference_date._thisptr), instruments, deref(daycounter._thisptr),
            i._thisptr,
            _pyc.PiecewiseYieldCurve[trait.ZeroYield, intpl.BackwardFlat].bootstrap_type(accuracy)
        )
        instance._thisptr.linkTo(shared_ptr[_yts.YieldTermStructure](instance._curve))
        return instance


    @property
    def data(self):
        """list of curve data"""
        return self._curve.data()
    @property
    def times(self):
        """list of curve times"""
        return self._curve.times()

    @property
    def dates(self):
        """list of curve dates"""
        cdef vector[_date.Date] _dates = self._curve.dates()
        cdef list r  = []
        cdef _date.Date qldate
        for qldate in _dates:
            r.append(date_from_qldate(qldate))

        return r

cdef class ForwardRateLinearPiecewiseYieldCurve(YieldTermStructure):
    def __init__(self, Natural settlement_days, Calendar calendar not None,
                 list helpers, DayCounter daycounter not None,
                 Linear i=Linear(),
                 Real accuracy = 1e-12):


        if len(helpers) == 0:
            raise ValueError('Cannot initialize curve with no helpers')

        # convert Python list to std::vector
        cdef vector[shared_ptr[_rh.RateHelper]] instruments

        for helper in helpers:
            instruments.push_back((<RateHelper?> helper)._thisptr)

        self._curve = new _pyc.PiecewiseYieldCurve[trait.ForwardRate, intpl.Linear](
            settlement_days, deref(calendar._thisptr), instruments,
            deref(daycounter._thisptr),
            i._thisptr,
            _pyc.PiecewiseYieldCurve[trait.ForwardRate, intpl.Linear].bootstrap_type(accuracy)
        )
        self._thisptr.linkTo(shared_ptr[_yts.YieldTermStructure](self._curve))

    @classmethod
    def from_reference_date(cls, Date reference_date, list helpers,
                            DayCounter daycounter not None, Linear i=Linear(),
                            Real accuracy=1e-12):

        if len(helpers) == 0:
            raise ValueError('Cannot initialize curve with no helpers')

        # convert Python list to std::vector
        cdef vector[shared_ptr[_rh.RateHelper]] instruments
        cdef ForwardRateLinearPiecewiseYieldCurve instance = cls.__new__(cls)

        for helper in helpers:
            instruments.push_back((<RateHelper?> helper)._thisptr)

        instance._curve = new _pyc.PiecewiseYieldCurve[trait.ForwardRate, intpl.Linear](
            deref(reference_date._thisptr), instruments, deref(daycounter._thisptr),
            i._thisptr,
            _pyc.PiecewiseYieldCurve[trait.ForwardRate, intpl.Linear].bootstrap_type(accuracy)
        )
        instance._thisptr.linkTo(shared_ptr[_yts.YieldTermStructure](instance._curve))
        return instance


    @property
    def data(self):
        """list of curve data"""
        return self._curve.data()
    @property
    def times(self):
        """list of curve times"""
        return self._curve.times()

    @property
    def dates(self):
        """list of curve dates"""
        cdef vector[_date.Date] _dates = self._curve.dates()
        cdef list r  = []
        cdef _date.Date qldate
        for qldate in _dates:
            r.append(date_from_qldate(qldate))

        return r

cdef class ForwardRateLogLinearPiecewiseYieldCurve(YieldTermStructure):
    def __init__(self, Natural settlement_days, Calendar calendar not None,
                 list helpers, DayCounter daycounter not None,
                 LogLinear i=LogLinear(),
                 Real accuracy = 1e-12):


        if len(helpers) == 0:
            raise ValueError('Cannot initialize curve with no helpers')

        # convert Python list to std::vector
        cdef vector[shared_ptr[_rh.RateHelper]] instruments

        for helper in helpers:
            instruments.push_back((<RateHelper?> helper)._thisptr)

        self._curve = new _pyc.PiecewiseYieldCurve[trait.ForwardRate, intpl.LogLinear](
            settlement_days, deref(calendar._thisptr), instruments,
            deref(daycounter._thisptr),
            i._thisptr,
            _pyc.PiecewiseYieldCurve[trait.ForwardRate, intpl.LogLinear].bootstrap_type(accuracy)
        )
        self._thisptr.linkTo(shared_ptr[_yts.YieldTermStructure](self._curve))

    @classmethod
    def from_reference_date(cls, Date reference_date, list helpers,
                            DayCounter daycounter not None, LogLinear i=LogLinear(),
                            Real accuracy=1e-12):

        if len(helpers) == 0:
            raise ValueError('Cannot initialize curve with no helpers')

        # convert Python list to std::vector
        cdef vector[shared_ptr[_rh.RateHelper]] instruments
        cdef ForwardRateLogLinearPiecewiseYieldCurve instance = cls.__new__(cls)

        for helper in helpers:
            instruments.push_back((<RateHelper?> helper)._thisptr)

        instance._curve = new _pyc.PiecewiseYieldCurve[trait.ForwardRate, intpl.LogLinear](
            deref(reference_date._thisptr), instruments, deref(daycounter._thisptr),
            i._thisptr,
            _pyc.PiecewiseYieldCurve[trait.ForwardRate, intpl.LogLinear].bootstrap_type(accuracy)
        )
        instance._thisptr.linkTo(shared_ptr[_yts.YieldTermStructure](instance._curve))
        return instance


    @property
    def data(self):
        """list of curve data"""
        return self._curve.data()
    @property
    def times(self):
        """list of curve times"""
        return self._curve.times()

    @property
    def dates(self):
        """list of curve dates"""
        cdef vector[_date.Date] _dates = self._curve.dates()
        cdef list r  = []
        cdef _date.Date qldate
        for qldate in _dates:
            r.append(date_from_qldate(qldate))

        return r

cdef class ForwardRateBackwardFlatPiecewiseYieldCurve(YieldTermStructure):
    def __init__(self, Natural settlement_days, Calendar calendar not None,
                 list helpers, DayCounter daycounter not None,
                 BackwardFlat i=BackwardFlat(),
                 Real accuracy = 1e-12):


        if len(helpers) == 0:
            raise ValueError('Cannot initialize curve with no helpers')

        # convert Python list to std::vector
        cdef vector[shared_ptr[_rh.RateHelper]] instruments

        for helper in helpers:
            instruments.push_back((<RateHelper?> helper)._thisptr)

        self._curve = new _pyc.PiecewiseYieldCurve[trait.ForwardRate, intpl.BackwardFlat](
            settlement_days, deref(calendar._thisptr), instruments,
            deref(daycounter._thisptr),
            i._thisptr,
            _pyc.PiecewiseYieldCurve[trait.ForwardRate, intpl.BackwardFlat].bootstrap_type(accuracy)
        )
        self._thisptr.linkTo(shared_ptr[_yts.YieldTermStructure](self._curve))

    @classmethod
    def from_reference_date(cls, Date reference_date, list helpers,
                            DayCounter daycounter not None, BackwardFlat i=BackwardFlat(),
                            Real accuracy=1e-12):

        if len(helpers) == 0:
            raise ValueError('Cannot initialize curve with no helpers')

        # convert Python list to std::vector
        cdef vector[shared_ptr[_rh.RateHelper]] instruments
        cdef ForwardRateBackwardFlatPiecewiseYieldCurve instance = cls.__new__(cls)

        for helper in helpers:
            instruments.push_back((<RateHelper?> helper)._thisptr)

        instance._curve = new _pyc.PiecewiseYieldCurve[trait.ForwardRate, intpl.BackwardFlat](
            deref(reference_date._thisptr), instruments, deref(daycounter._thisptr),
            i._thisptr,
            _pyc.PiecewiseYieldCurve[trait.ForwardRate, intpl.BackwardFlat].bootstrap_type(accuracy)
        )
        instance._thisptr.linkTo(shared_ptr[_yts.YieldTermStructure](instance._curve))
        return instance


    @property
    def data(self):
        """list of curve data"""
        return self._curve.data()
    @property
    def times(self):
        """list of curve times"""
        return self._curve.times()

    @property
    def dates(self):
        """list of curve dates"""
        cdef vector[_date.Date] _dates = self._curve.dates()
        cdef list r  = []
        cdef _date.Date qldate
        for qldate in _dates:
            r.append(date_from_qldate(qldate))

        return r

