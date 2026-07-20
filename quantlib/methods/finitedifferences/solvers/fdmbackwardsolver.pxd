cimport quantlib.methods.finitedifferences.solvers._fdmbackwardsolver as _fdm

cdef extern from 'ql/methods/finitedifferences/solvers/fdmbackwardsolver.hpp' namespace 'QuantLib::FdmSchemeDesc':
    cpdef enum FdmSchemeType:
        """Finite-difference scheme types for PDE solvers.

        =====================  =========================================
        Value                  Description
        =====================  =========================================
        HundsdorferType        Hundsdorfer scheme
        DouglasType            Douglas scheme
        CraigSneydType         Craig-Sneyd scheme
        ModifiedCraigSneydType Modified Craig-Sneyd scheme
        ImplicitEulerType      Implicit Euler scheme
        ExplicitEulerType      Explicit Euler scheme
        MethodOfLinesType      Method of lines
        TrBDF2Type             TR-BDF2 scheme
        CrankNicolsonType      Crank-Nicolson scheme
        =====================  =========================================
        """
        HundsdorferType
        DouglasType
        CraigSneydType
        ModifiedCraigSneydType
        ImplicitEulerType
        ExplicitEulerType
        MethodOfLinesType
        TrBDF2Type
        CrankNicolsonType

cdef class FdmSchemeDesc:
    cdef _fdm.FdmSchemeDesc* _thisptr
