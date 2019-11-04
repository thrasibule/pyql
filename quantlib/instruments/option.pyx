include '../types.pxi'

# Cython imports
from cython.operator cimport dereference as deref
from libcpp cimport bool
from libcpp.vector cimport vector

from . cimport _option
from . cimport _payoffs
cimport quantlib.instruments._instrument as _instrument
cimport quantlib.time._date as _date
cimport quantlib.pricingengines._pricing_engine as _pe
cimport quantlib.processes._black_scholes_process as _bsp

from quantlib.handle cimport shared_ptr, static_pointer_cast
from quantlib.instruments.instrument cimport Instrument
from quantlib.instruments.payoffs cimport Payoff, PlainVanillaPayoff
from quantlib.time.date cimport Date
from quantlib.pricingengines.engine cimport PricingEngine
from quantlib.processes.black_scholes_process cimport GeneralizedBlackScholesProcess

cpdef enum ExerciseType:
    American = _exercise.American
    Bermudan  = _exercise.Bermudan
    European = _exercise.European

cpdef enum OptionType:
    Call = _option.Type.Call
    Put  = _option.Type.Put

EXERCISE_TO_STR = {
    American : 'American',
    Bermudan : 'Bermudan',
    European : 'European'
}

cdef class Exercise:

    def __str__(self):
        return 'Exercise type: %s' % EXERCISE_TO_STR[self._thisptr.get().type()]

cdef class EuropeanExercise(Exercise):

    def __init__(self, Date exercise_date not None):
        self._thisptr = shared_ptr[_exercise.Exercise]( \
            new _exercise.EuropeanExercise(
                deref(exercise_date._thisptr)
            )
        )

cdef class AmericanExercise(Exercise):

    def __init__(self, Date latest_exercise_date, Date earliest_exercise_date=None):
        """ Creates an AmericanExercise.

        :param latest_exercise_date: Latest exercise date for the option
        :param earliest_exercise_date: Earliest exercise date for the option (default to None)

        """
        if earliest_exercise_date is not None:
            self._thisptr = shared_ptr[_exercise.Exercise]( \
                new _exercise.AmericanExercise(
                    deref(earliest_exercise_date._thisptr),
                    deref(latest_exercise_date._thisptr)
                )
            )
        else:
            self._thisptr = shared_ptr[_exercise.Exercise]( \
                new _exercise.AmericanExercise(
                    deref(latest_exercise_date._thisptr)
                )
            )


cdef class Option(Instrument):

    cdef inline _option.Option* _get_option(self):
        return <_option.Option*>self._thisptr.get()

    def __init__(self):
        raise NotImplementedError(
            'Cannot implement this abstract class. Use child like the '
            'VanillaOption'
        )

    @property
    def exercise(self):
        cdef Exercise exercise = Exercise.__new__(Exercise)
        exercise._thisptr = self._get_option().exercise()
        return exercise

    @property
    def payoff(self):
        cdef Payoff payoff = Payoff.__new__(Payoff)
        payoff._thisptr = self._get_option().payoff()
        return payoff

    def __str__(self):
        return '%s %s %s' % (
            type(self).__name__, str(self.exercise), str(self.payoff)
        )

cdef class OneAssetOption(Option):

    cdef inline _option.OneAssetOption* _get_one_asset_option(self):
        return <_option.OneAssetOption*>self._thisptr.get()

    @property
    def delta(self):
        return self._get_one_asset_option().delta()

    @property
    def delta_forward(self):
        return self._get_one_asset_option().deltaForward()

    @property
    def elasticity(self):
        return self._get_one_asset_option().elasticity()

    @property
    def gamma(self):
        return self._get_one_asset_option().gamma()

    @property
    def theta(self):
        return self._get_one_asset_option().theta()

    @property
    def theta_per_day(self):
        return self._get_one_asset_option().thetaPerDay()

    @property
    def vega(self):
        return self._get_one_asset_option().vega()

    @property
    def rho(self):
        return self._get_one_asset_option().rho()

    @property
    def dividend_rho(self):
        return self._get_one_asset_option().dividendRho()

    @property
    def strike_sensitivity(self):
        return self._get_one_asset_option().strikeSensitivity()

    @property
    def itm_cash_probability(self):
        return self._get_one_asset_option().itmCashProbability()


cdef class VanillaOption(OneAssetOption):

    def __init__(self, PlainVanillaPayoff payoff not None, Exercise exercise not None):

        self._thisptr = shared_ptr[_instrument.Instrument]( \
            new _option.VanillaOption(
                static_pointer_cast[_payoffs.StrikedTypePayoff](payoff._thisptr),
                                      exercise._thisptr)
        )


    def implied_volatility(self, Real target_value,
        GeneralizedBlackScholesProcess process, Real accuracy, Size max_evaluations,
        Volatility min_vol, Volatility max_vol):

        cdef shared_ptr[_bsp.GeneralizedBlackScholesProcess] process_ptr = \
            static_pointer_cast[_bsp.GeneralizedBlackScholesProcess](process._thisptr)

        vol = (<_option.VanillaOption *> self._thisptr.get()).impliedVolatility(
            target_value, process_ptr, accuracy, max_evaluations, min_vol, max_vol)

        return vol

cdef class EuropeanOption(VanillaOption):

    def __init__(self, PlainVanillaPayoff payoff not None, Exercise exercise not None):

        cdef shared_ptr[_payoffs.StrikedTypePayoff] payoff_ptr = \
            static_pointer_cast[_payoffs.StrikedTypePayoff](
                payoff._thisptr)

        self._thisptr = shared_ptr[_instrument.Instrument]( \
            new _option.EuropeanOption(payoff_ptr, exercise._thisptr)
        )

cdef class DividendVanillaOption(OneAssetOption):
    """ Single-asset vanilla option (no barriers) with discrete dividends. """

    def __init__(self, PlainVanillaPayoff payoff not None, Exercise exercise not None,
                 dividend_dates, vector[Real] dividends):

        cdef shared_ptr[_payoffs.StrikedTypePayoff] payoff_ptr = \
            static_pointer_cast[_payoffs.StrikedTypePayoff](payoff._thisptr)

        # convert the list of PyQL dates into a vector of QL dates
        cdef vector[_date.Date] _dividend_dates
        for date in dividend_dates:
            _dividend_dates.push_back(deref((<Date>date)._thisptr))

        self._thisptr = shared_ptr[_instrument.Instrument]( \
            new _option.DividendVanillaOption(
                payoff_ptr, exercise._thisptr, _dividend_dates,
                dividends
            )
        )


    def implied_volatility(self, Real target_value,
        GeneralizedBlackScholesProcess process, Real accuracy, Size max_evaluations,
        Volatility min_vol, Volatility max_vol):

        cdef shared_ptr[_bsp.GeneralizedBlackScholesProcess] process_ptr = \
            static_pointer_cast[_bsp.GeneralizedBlackScholesProcess](process._thisptr)

        vol = (<_option.DividendVanillaOption *> self._thisptr.get()).impliedVolatility(
            target_value, process_ptr, accuracy, max_evaluations, min_vol, max_vol)

        return vol
