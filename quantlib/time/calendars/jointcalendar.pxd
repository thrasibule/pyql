from quantlib.time.calendar cimport Calendar

cdef extern from 'ql/time/calendars/jointcalendar.hpp' namespace 'QuantLib' nogil:

    cpdef enum JointCalendarRule:
        """Rules for joining calendars.

        ================  ================================================
        Value             Description
        ================  ================================================
        JoinHolidays      A date is a holiday if it is a holiday for any
                          of the given calendars
        JoinBusinessDays  A date is a business day if it is a business day
                          for any of the given calendars
        ================  ================================================
        """
        JoinHolidays
        JoinBusinessDays

cdef class JointCalendar(Calendar):
    pass

