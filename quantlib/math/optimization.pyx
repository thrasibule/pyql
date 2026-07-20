from quantlib.ext cimport shared_ptr, make_shared

from . cimport _optimization as _opt
from quantlib.math.array cimport Array

cdef class OptimizationMethod:
    """Abstract class for constrained optimization method.

    This is the base class for all optimization methods in QuantLib.
    Concrete implementations include :class:`LevenbergMarquardt`,
    ``Simplex``, ``ConjugateGradient``, and ``BFGS``.
    """
    pass

cdef class LevenbergMarquardt(OptimizationMethod):
    """Levenberg-Marquardt optimization method.

    This method is suitable for solving non-linear least-squares problems.
    It combines the Gauss-Newton algorithm with gradient descent.

    Parameters
    ----------
    epsfcn : float, optional
        Step length for the forward-difference approximation of the
        Jacobian. Default is 1e-8.
    xtol : float, optional
        Relative tolerance for the solution. Default is 1e-8.
    gtol : float, optional
        Tolerance for the norm of the gradient. Default is 1e-8.
    """

    def __init__(self, double epsfcn=1e-8, double xtol=1e-8, double gtol=1e-8):
        self._thisptr = shared_ptr[_opt.OptimizationMethod](
            new _opt.LevenbergMarquardt(
                epsfcn,
                xtol,
                gtol
            )
        )

cdef class EndCriteria:
    """Criteria to end optimization process.

    Stopping criteria are based on:

    - Maximum number of iterations
    - Minimum number of iterations around stationary point
    - x (independent variable) stationary point
    - y=f(x) (dependent variable) stationary point
    - Stationary gradient

    Parameters
    ----------
    max_iterations : int
        Maximum number of iterations.
    max_stationary_state_iterations : int
        Maximum number of iterations in stationary state.
    root_epsilon : float
        Epsilon for root (independent variable) stationary test.
    function_epsilon : float
        Epsilon for function value stationary test.
    gradient_epsilon : float
        Epsilon for gradient norm test.
    """

    def __init__(self, int max_iterations, int max_stationary_state_iterations,
            double root_epsilon, double function_epsilon,
            double gradient_epsilon
    ):
        self._thisptr = make_shared[_opt.EndCriteria](
                max_iterations,
                max_stationary_state_iterations,
                root_epsilon,
                function_epsilon,
                gradient_epsilon
        )


cdef class Constraint:
    """Base class for optimization constraints.

    This class represents a constraint for constrained optimization.
    The :meth:`test` method checks whether a given point satisfies
    the constraint.
    """

    def __cinit__(self):
        self._thisptr = make_shared[_opt.Constraint]()

    def test(self, Array a):
        """Tests whether the given point satisfies the constraint.

        Parameters
        ----------
        a : :class:`~quantlib.math.array.Array`
            The point to test.

        Returns
        -------
        bool
            ``True`` if the point satisfies the constraint.
        """
        return self._thisptr.get().test(a._thisptr)
