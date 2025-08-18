include '../../../types.pxi'
from libcpp cimport bool
from cython.operator cimport dereference as deref
from quantlib.time.date cimport Date, Period
from ..smilesection cimport SmileSection
from ..volatilitytype import VolatilityType

cdef class SwaptionVolatilityStructure(VolatilityTermStructure):

    cdef inline _svs.SwaptionVolatilityStructure* get_svs(self) nogil:
        return <_svs.SwaptionVolatilityStructure*>self._thisptr.get()

    def volatility(self, option_date, swap_date, Rate strike,
                   bool extrapolate=False):
        if isinstance(swap_date, Period):
            if isinstance(option_date, Period):
                return self.get_svs().volatility(
                    deref((<Period>option_date)._thisptr),
                    deref((<Period>swap_date)._thisptr),
                    strike,
                    extrapolate)
            elif isinstance(option_date, Date):
                return self.get_svs().volatility(
                    (<Date>option_date)._thisptr,
                    deref((<Period>swap_date)._thisptr),
                    strike,
                    extrapolate)
            elif isinstance(option_date, float):
                return self.get_svs().volatility(
                    <Time>option_date,
                    deref((<Period>swap_date)._thisptr),
                    strike,
                    extrapolate)
            else:
                raise TypeError('option_date needs to be a Period, Date or Time')
        elif isinstance(swap_date, float):
            if isinstance(option_date, Period):
                return self.get_svs().volatility(
                    deref((<Period>option_date)._thisptr),
                    <Time>swap_date,
                    strike,
                    extrapolate)
            elif isinstance(option_date, Date):
                return self.get_svs().volatility(
                    (<Date>option_date)._thisptr,
                    <Time>swap_date,
                    strike,
                    extrapolate)
            elif isinstance(option_date, float):
                return self.get_svs().volatility(
                    <Time>option_date,
                    <Time>swap_date,
                    strike,
                    extrapolate)
            else:
                raise TypeError('option_date needs to be a Period, Date or Time')
        else:
            raise TypeError('swap_date needs to be a Period or a Time')


    def smile_section(self, Period option_tenor not None,
                      Period swap_tenor not None,
                      bool extrapolation=False):
        cdef SmileSection r = SmileSection.__new__(SmileSection)
        r._thisptr = self.get_svs().smileSection(deref(option_tenor._thisptr),
                                                      deref(swap_tenor._thisptr),
                                                      extrapolation)
        return r

    def black_variance(self, option_date, swap_date, Rate strike,
                       bool extrapolate=False):
        if isinstance(swap_date, Period):
            if isinstance(option_date, Period):
                return self.get_svs().blackVariance(
                    deref((<Period>option_date)._thisptr),
                    deref((<Period>swap_date)._thisptr),
                    strike,
                    extrapolate)
            elif isinstance(option_date, Date):
                return self.get_svs().blackVariance(
                    (<Date>option_date)._thisptr,
                    deref((<Period>swap_date)._thisptr),
                    strike,
                    extrapolate)
            elif isinstance(option_date, float):
                return self.get_svs().blackVariance(
                    <Time>option_date,
                    deref((<Period>swap_date)._thisptr),
                    strike,
                    extrapolate)
            else:
                raise TypeError('option_date needs to be a Period, Date or Time')
        elif isinstance(swap_date, float):
            if isinstance(option_date, Period):
                return self.get_svs().blackVariance(
                    deref((<Period>option_date)._thisptr),
                    <Time>swap_date,
                    strike,
                    extrapolate)
            elif isinstance(option_date, Date):
                return self.get_svs().blackVariance(
                    (<Date>option_date)._thisptr,
                    <Time>swap_date,
                    strike,
                    extrapolate)
            elif isinstance(option_date, float):
                return self.get_svs().blackVariance(
                    <Time>option_date,
                    <Time>swap_date,
                    strike,
                    extrapolate)
            else:
                raise TypeError('option_date needs to be a Period, Date or Time')
        else:
            raise TypeError('swap_date needs to be a Period or a Time')

    def shift(self, option_date, swap_date, bool extrapolate=False):
        if isinstance(swap_date, Period):
            if isinstance(option_date, Period):
                return self.get_svs().shift(
                    deref((<Period>option_date)._thisptr),
                    deref((<Period>swap_date)._thisptr),
                    extrapolate)
            elif isinstance(option_date, Date):
                return self.get_svs().shift(
                    (<Date>option_date)._thisptr,
                    deref((<Period>swap_date)._thisptr),
                    extrapolate)
            elif isinstance(option_date, float):
                return self.get_svs().shift(
                    <Time>option_date,
                    deref((<Period>swap_date)._thisptr),
                    extrapolate)
            else:
                raise TypeError('option_date needs to be a Period, Date or Time')
        elif isinstance(swap_date, float):
            if isinstance(option_date, Period):
                return self.get_svs().shift(
                    deref((<Period>option_date)._thisptr),
                    <Time>swap_date,
                    extrapolate)
            elif isinstance(option_date, Date):
                return self.get_svs().shift(
                    (<Date>option_date)._thisptr,
                    <Time>swap_date,
                    extrapolate)
            elif isinstance(option_date, float):
                return self.get_svs().shift(
                    <Time>option_date,
                    <Time>swap_date,
                    extrapolate)
            else:
                raise TypeError('option_date needs to be a Period, Date or Time')
        else:
            raise TypeError('swap_date needs to be a Period or a Time')

    @property
    def volatility_type(self):
        return VolatilityType(self.get_svs().volatilityType())
