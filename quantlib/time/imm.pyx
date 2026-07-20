# Copyright (C) 2014, Enthought Inc
# Copyright (C) 2014, Patrick Henaff
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the license for more details.

from cython.operator cimport dereference as deref
from libcpp cimport bool
from libcpp.string cimport string
cimport quantlib.time._date as _date
cimport quantlib.time._imm as _imm

from quantlib.time.date cimport Date
from quantlib.time.date cimport date_from_qldate

# See runtime __doc__ assignment below for documentation.
cpdef enum Month:
    F = _imm.F
    G = _imm.G
    H = _imm.H
    J = _imm.J
    K = _imm.K
    M = _imm.M
    N = _imm.N
    Q = _imm.Q
    U = _imm.U
    V = _imm.V
    X = _imm.X
    Z = _imm.Z

# cpdef enum in Cython drops docstrings at compile time,
# so we set it at runtime.
Month.__doc__ = """\
Main cycle of the International Money Market (a.k.a. IMM) months.

The IMM months are designated by letter codes:

- F = January
- G = February
- H = March
- J = April
- K = May
- M = June
- N = July
- Q = August
- U = September
- V = October
- X = November
- Z = December

These codes are used to identify futures contracts on the Chicago
Mercantile Exchange (CME).
"""

def is_IMM_date(Date dt, bool main_cycle=True):
    """Returns whether or not the given date is an IMM date.

    Parameters
    ----------
    dt : :class:`~quantlib.time.date.Date`
        The date to check.
    main_cycle : bool, optional
        If ``True`` (default), only dates in the main cycle (March,
        June, September, December) are considered IMM dates.

    Returns
    -------
    bool
        ``True`` if the date is an IMM date, ``False`` otherwise.
    """
    return _imm.isIMMdate(dt._thisptr, main_cycle)

def is_IMM_code(str imm_code, bool main_cycle=True):
    """Returns whether or not the given string is an IMM code.

    Parameters
    ----------
    imm_code : str
        The string to check (e.g., ``"H3"`` for March 2013).
    main_cycle : bool, optional
        If ``True`` (default), only codes in the main cycle are
        considered IMM codes.

    Returns
    -------
    bool
        ``True`` if the string is a valid IMM code, ``False`` otherwise.
    """
    cdef string _code = imm_code.encode('utf-8')
    return _imm.isIMMcode(_code, main_cycle)

def code(Date imm_date):
    """Returns the IMM code for the given date (e.g. ``"H3"`` for March
    20th, 2013).

    Parameters
    ----------
    imm_date : :class:`~quantlib.time.date.Date`
        The IMM date.

    Returns
    -------
    str
        The IMM code string.

    Raises
    ------
    RuntimeError
        If the input date is not an IMM date.
    """
    cdef string _code = _imm.code(imm_date._thisptr)
    return _code.decode("utf-8")

def date(str imm_code, Date reference_date=Date()):
    """Returns the IMM date for the given IMM code (e.g. March 20th,
    2013 for ``"H3"``).

    Parameters
    ----------
    imm_code : str
        The IMM code string (e.g., ``"H3"``, ``"M23"``).
    reference_date : :class:`~quantlib.time.date.Date`, optional
        A reference date used to resolve the year of the IMM code.
        Defaults to the null date.

    Returns
    -------
    :class:`~quantlib.time.date.Date`
        The IMM date corresponding to the given code.

    Raises
    ------
    RuntimeError
        If the input string is not a valid IMM code.
    """
    cdef string _code = imm_code.encode('utf-8')
    cdef _date.Date tmp = _imm.date(_code, reference_date._thisptr)
    return date_from_qldate(tmp)

def next_date(code_or_date, bool main_cycle=True, Date reference_date=Date()):
    """Next IMM date following the given date or IMM code.

    Returns the 1st delivery date for next contract listed in the
    International Money Market section of the Chicago Mercantile
    Exchange.

    Parameters
    ----------
    code_or_date : :class:`~quantlib.time.date.Date` or str
        Either a starting date or an IMM code string.
    main_cycle : bool, optional
        If ``True`` (default), only dates in the main cycle are considered.
    reference_date : :class:`~quantlib.time.date.Date`, optional
        A reference date used when ``code_or_date`` is a string.

    Returns
    -------
    :class:`~quantlib.time.date.Date`
        The next IMM date.
    """

    cdef _date.Date result

    cdef Date dt

    if isinstance(code_or_date, Date):
        dt = <Date>code_or_date
        result =  _imm.nextDate(dt._thisptr, main_cycle)
    else:
        result =  _imm.nextDate(code_or_date.encode('utf-8'),
                                main_cycle, reference_date._thisptr)

    return date_from_qldate(result)

def next_code(code_or_date, bool main_cycle=True, Date reference_date=Date()):
    """Next IMM code following the given date or code.

    Returns the IMM code for next contract listed in the
    International Money Market section of the Chicago Mercantile Exchange.

    Parameters
    ----------
    code_or_date : :class:`~quantlib.time.date.Date` or str
        Either a starting date or an IMM code string.
    main_cycle : bool, optional
        If ``True`` (default), only codes in the main cycle are considered.
    reference_date : :class:`~quantlib.time.date.Date`, optional
        A reference date used when ``code_or_date`` is a string.

    Returns
    -------
    str
        The next IMM code string.
    """

    cdef Date dt
    cdef string result

    if isinstance(code_or_date, Date):
        dt = <Date> code_or_date
        result =  _imm.nextCode(dt._thisptr, main_cycle)
    else:
        result =  _imm.nextCode(code_or_date.encode('utf-8'),
                                main_cycle,
                                reference_date._thisptr)

    return result.decode("utf-8")
