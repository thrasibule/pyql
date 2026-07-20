from quantlib.types cimport Size, Time
from libcpp.vector cimport vector
from . cimport _time_grid as _tg

cdef class TimeGrid:
    """Discrete time grid.

    This class represents a discrete time grid used for numerical
    methods such as finite difference solvers. The grid can be
    constructed with regular spacing or with mandatory time points.

    Parameters
    ----------
    end : float
        The end time of the grid.
    steps : int
        The number of steps to divide the time interval into.
    """

    def __init__(self, Time end, Size steps):
        """Construct a regularly spaced time grid from 0 to ``end``
        with the given number of steps.

        Parameters
        ----------
        end : float
            The end time of the grid.
        steps : int
            The number of steps.
        """
        self._thisptr = _tg.TimeGrid(end, steps)

    @classmethod
    def from_vector(cls, vector[Time] l):
        """Construct a time grid with mandatory time points.

        Mandatory points are guaranteed to belong to the grid.
        No additional points are added.

        Parameters
        ----------
        l : list of float
            List of mandatory time points.

        Returns
        -------
        :class:`TimeGrid`
            A new TimeGrid instance.
        """
        cdef TimeGrid instance = cls.__new__(cls)
        instance._thisptr = _tg.TimeGrid(l.begin(), l.end())
        return instance

    def __len__(self):
        """Returns the number of points in the time grid.

        Returns
        -------
        int
        """
        return self._thisptr.size()

    def __iter__(self):
        cdef Size i
        for i in range(self._thisptr.size()):
            yield self._thisptr[i]

    def __getitem__(self, index):
        """Returns the time point at the given index.

        Parameters
        ----------
        index : int or slice
            The index or slice of the time point(s) to retrieve.

        Returns
        -------
        float or list of float
        """
        cdef size_t i
        if isinstance(index, slice):
            return [self._thisptr.at(i)
                    for i in range(*index.indices(len(self)))]
        elif isinstance(index, int):
            return self._thisptr.at(index)
        else:
            raise TypeError('index needs to be an integer or a slice')
