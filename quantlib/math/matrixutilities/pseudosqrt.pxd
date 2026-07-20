from .._matrix cimport Matrix

cdef extern from 'ql/math/matrixutilities/pseudosqrt.hpp' namespace 'QuantLib::SalvagingAlgorithm':
    cpdef enum SalvagingAlgorithm "QuantLib::SalvagingAlgorithm::Type":
        """Algorithm for computing the pseudo-square-root of a matrix.

        =============  ================================================
        Value          Description
        =============  ================================================
        Nothing        No salvaging (None)
        Spectral       Spectral method
        Hypersphere    Hypersphere decomposition
        LowerDiagonal  Lower-diagonal decomposition
        Higham         Higham's method
        =============  ================================================
        """
        Nothing "QuantLib::SalvagingAlgorithm::None"
        Spectral
        Hypersphere
        LowerDiagonal
        Higham

cdef extern from 'ql/math/matrixutilities/pseudosqrt.hpp' namespace 'QuantLib':
    const Matrix pseudoSqrt(const Matrix&, SalvagingAlgorithm)
