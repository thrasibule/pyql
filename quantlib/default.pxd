cdef extern from 'ql/default.hpp' namespace 'QuantLib::Protection':
    cpdef enum class Protection "QuantLib::Protection::Side":
        """Protection side for credit default swaps: Buyer or Seller."""
        Buyer
        Seller
