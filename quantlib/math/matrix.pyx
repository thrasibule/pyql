include '../types.pxi'
from cython.operator import dereference as deref, preincrement as preinc
from libcpp.utility cimport move

cimport cython
cimport numpy as np
np.import_array()

cdef class Matrix:
    """Matrix used in linear algebra.

    This class implements the concept of a matrix as used in linear
    algebra. As such, it is **not** meant to be used as a container.

    Parameters
    ----------
    rows : int
        Number of rows.
    columns : int
        Number of columns.
    value : float, optional
        Value to fill the matrix with. If not provided, the matrix
        is left uninitialized.
    """

    def __init__(self, Size rows, Size columns, value=None):
        if value is None:
            self._thisptr = move[QlMatrix](QlMatrix(rows, columns))
        else:
            self._thisptr = move[QlMatrix](QlMatrix(rows, columns, <Real?>value))

    @classmethod
    @cython.boundscheck(False)
    def from_ndarray(cls, double[:,::1] data):
        """Creates a Matrix from a numpy 2-D array.

        Parameters
        ----------
        data : numpy.ndarray
            A 2-D numpy array of ``double`` values.

        Returns
        -------
        :class:`Matrix`
        """
        cdef Matrix instance = Matrix.__new__(Matrix)
        cdef Size rows = data.shape[0]
        cdef Size columns = data.shape[1]
        instance._thisptr = QlMatrix(rows, columns, &data[0,0], &data[-1,-1] + 1)
        return instance

    @cython.boundscheck(False)
    def to_ndarray(self):
        """Converts the matrix to a numpy 2-D array.

        Returns
        -------
        numpy.ndarray
        """
        cdef np.npy_intp[2] dims
        dims[0] = self._thisptr.rows()
        dims[1] = self._thisptr.columns()
        cdef arr = np.PyArray_SimpleNew(2, &dims[0], np.NPY_DOUBLE)
        cdef double[:,::1] r = arr
        cdef np.npy_intp i, j
        for i in range(dims[0]):
            for j in range(dims[1]):
                r[i,j] = self._thisptr[i][j]
        return arr

    @property
    def rows(self):
        """Returns the number of rows.

        Returns
        -------
        int
        """
        return self._thisptr.rows()

    @property
    def columns(self):
        """Returns the number of columns.

        Returns
        -------
        int
        """
        return self._thisptr.columns()

    def __getitem__(self, coord):
        cdef size_t i, j
        i = coord[0]
        j = coord[1]
        return self._thisptr[i][j]

    def __setitem__(self, coord, Real val):
        cdef size_t i, j
        i, j = coord
        self._thisptr[i][j] = val
