cpdef enum BootstrapTrait:
    """Bootstrap traits for piecewise yield curve construction.

    Determines the type of rate being interpolated:

    - **Discount**:    Discount factors are interpolated
    - **ZeroYield**:   Zero-coupon yields are interpolated
    - **ForwardRate**: Forward rates are interpolated
    """
    Discount
    ZeroYield
    ForwardRate
