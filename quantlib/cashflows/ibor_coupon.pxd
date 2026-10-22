from . cimport _ibor_coupon as _ic
from quantlib.cashflows.floating_rate_coupon cimport FloatingRateCoupon
from quantlib.cashflow cimport Leg

cdef class IborCoupon(FloatingRateCoupon):
    pass

cdef class IborLeg(Leg):
    cdef _ic.IborLeg* leg

cdef class IborCouponSettings:
    pass
