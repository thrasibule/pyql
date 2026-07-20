from quantlib.types cimport Real, Natural
from quantlib.ext cimport static_pointer_cast
from quantlib.time.date cimport Date
from quantlib.time.calendar cimport Calendar
from quantlib.time.businessdayconvention cimport BusinessDayConvention, Following
from quantlib.indexes.ibor_index cimport IborIndex
from quantlib.indexes cimport _ibor_index as _ib
from . cimport _zerocouponswap as _zcs

cdef class ZeroCouponSwap(Swap):
    """Zero-coupon swap.

    A zero-coupon swap is a swap where the fixed leg consists of a single
    payment at maturity (a zero-coupon bond), while the floating leg follows
    a standard Ibor index schedule.

    Parameters
    ----------
    type : :class:`~quantlib.instruments.swap.Type`
        The swap type: ``Payer`` or ``Receiver``.
    nominal : float
        The notional amount of the swap.
    start_date : :class:`~quantlib.time.date.Date`
        The start date of the swap.
    maturity : :class:`~quantlib.time.date.Date`
        The maturity date of the swap.
    fixed_payment : float
        The single fixed payment amount at maturity.
    ibor_index : :class:`~quantlib.indexes.ibor_index.IborIndex`
        The Ibor index for the floating leg.
    payment_calendar : :class:`~quantlib.time.calendar.Calendar`
        Calendar for payment adjustments.
    payment_convention : int, optional
        Business day convention for payments. Defaults to ``Following``.
    payment_delay : int, optional
        Payment delay in days. Default is 0.
    """

    def __init__(self, Type type, Real nominal, Date start_date, Date maturity, Real fixed_payment, IborIndex ibor_index, Calendar payment_calendar, BusinessDayConvention payment_convention=Following, Natural payment_delay=0):
        self._thisptr.reset(
            new _zcs.ZeroCouponSwap(
                type,
                nominal,
                start_date._thisptr,
                maturity._thisptr,
                fixed_payment,
                static_pointer_cast[_ib.IborIndex](ibor_index._thisptr),
                payment_calendar._thisptr,
                payment_convention,
                payment_delay
            )
        )
