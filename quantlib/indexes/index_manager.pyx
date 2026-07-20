# cython: c_string_type=unicode, c_string_encoding=ascii
cimport quantlib.indexes._index_manager as _im

cdef class IndexManager:
    """Global repository for past index fixings.

    The IndexManager is a singleton that stores historical fixings for
    all indexes. It provides access to past fixing values through the
    :meth:`histories` method.

    .. note::
        Index names are case insensitive.
    """

    @staticmethod
    def histories():
        """Returns the dictionary of historical fixings for all indexes.

        Returns
        -------
        dict
            A dictionary mapping index names to their historical
            :class:`~quantlib.time_series.TimeSeries`.
        """
        return _im.IndexManager.instance().histories()
