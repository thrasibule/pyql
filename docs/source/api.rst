Reference documentation for the :mod:`quantlib` package
=======================================================

The API of the Python wrappers try to be as close as possible to the C++
original source but keeping a Pythonic simple access to classes, methods and
functions. Most of the complex structures related to proper memory management
are completely hidden being the Python layers (for example boost::shared_ptr and Handle).

:mod:`quantlib`
---------------

:mod:`quantlib.settings`
^^^^^^^^^^^^^^^^^^^^^^^^
.. automodule:: quantlib.settings
    :members:
    :undoc-members:
    :noindex:

:mod:`quantlib.quotes`
^^^^^^^^^^^^^^^^^^^^^^
.. automodule:: quantlib.quotes
    :members:
    :undoc-members:
    :noindex:

:mod:`quantlib.cashflow`
^^^^^^^^^^^^^^^^^^^^^^^^
.. automodule:: quantlib.cashflow
    :members:
    :undoc-members:
    :noindex:

:mod:`quantlib.index`
^^^^^^^^^^^^^^^^^^^^^
.. automodule:: quantlib.index
    :members:
    :undoc-members:
    :noindex:

:mod:`quantlib.interest_rate`
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. automodule:: quantlib.interest_rate
    :members:
    :noindex:

.. currentmodule:: quantlib.currency.currencies

**Currencies**

.. autosummary::
    USDCurrency
    EURCurrency

:mod:`quantlib.currency`
------------------------

:mod:`quantlib.currency.currency`
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. automodule:: quantlib.currency.currency
    :members:
    :undoc-members:
    :noindex:

:mod:`quantlib.currency.currencies`
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. automodule:: quantlib.currency.currencies
    :members:
    :undoc-members:
    :noindex:


:mod:`quantlib.indexes`
-----------------------

.. currentmodule:: quantlib.indexes.interest_rate_index

.. autoclass:: InterestRateIndex
    :members:
    :noindex:

.. currentmodule:: quantlib.indexes.ibor_index

.. autoclass:: IborIndex
    :members:
    :noindex:

.. automodule:: quantlib.indexes.ibor
    :members:
    :noindex:

:mod:`quantlib.instruments`
---------------------------

:mod:`quantlib.instruments.bonds`
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. automodule:: quantlib.instruments.bonds
    :members:
    :noindex:

:mod:`quantlib.instruments.option`
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. automodule:: quantlib.instruments.option
    :members:
    :noindex:

:mod:`quantlib.instruments.credit_default_swap`
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. automodule:: quantlib.instruments.credit_default_swap
    :members:
    :noindex:

.. currentmodule:: quantlib.instruments.credit_default_swap
.. autodata

quantlib.math
-------------

.. automodule:: quantlib.math.optimization
    :members:
    :undoc-members:
    :noindex:


quantlib.model.equity
---------------------

.. currentmodule:: quantlib.models.equity.heston_model

.. autoclass:: HestonModel
    :members:
    :noindex:

.. autoclass:: HestonModelHelper
    :members:
    :noindex:

.. automodule:: quantlib.models.equity.bates_model
    :members:
    :noindex:

:mod:`quantlib.pricingengines`
------------------------------

.. automodule:: quantlib.pricingengines.blackformula

.. automodule:: quantlib.pricingengines.vanilla.vanilla
   :members:
   :undoc-members:
   :noindex:

:mod:`quantlib.pricingengines.swaption`
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. automodule:: quantlib.pricingengines.swaption
   :members:
   :undoc-members:
   :noindex:

:mod:`quantlib.processes`
-------------------------

.. currentmodule:: quantlib.processes.black_scholes_process

.. autoclass:: GeneralizedBlackScholesProcess
    :members:
    :noindex:

.. autoclass:: BlackScholesMertonProcess
    :members:
    :noindex:

.. currentmodule:: quantlib.processes.bates_process

.. autoclass:: BatesProcess
    :members:
    :noindex:

.. currentmodule:: quantlib.processes.heston_process

.. autoclass:: HestonProcess
    :members:
    :noindex:

:mod:`quantlib.termstructures`
------------------------------

.. automodule:: quantlib.termstructures.volatility.equityfx.black_vol_term_structure
   :members:
   :noindex:

:mod:`quantlib.termstructures.inflation_term_structure`
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. automodule:: quantlib.termstructures.inflation_term_structure
   :members:
   :noindex:

:mod:`quantlib.termstructures.default_term_structure`
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. automodule:: quantlib.termstructures.default_term_structure
   :members:
   :undoc-members:
   :noindex:

:mod:`~quantlib.termstructures.yield_term_structure`
""""""""""""""""""""""""""""""""""""""""""""""""""""
.. automodule:: quantlib.termstructures.yield_term_structure
   :members:
   :undoc-members:
   :noindex:

::mod:`quantlib.termstructures.yields`
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

mod:`~quantlib.termstructures.yields.rate_helpers`
"""""""""""""""""""""""""""""""""""""""""""""""""""
.. automodule:: quantlib.termstructures.yields.rate_helpers
    :members:
    :noindex:

:mod:`~quantlib.termstructures.yields.bond_helpers`
"""""""""""""""""""""""""""""""""""""""""""""""""""
.. automodule:: quantlib.termstructures.yields.bond_helpers
    :members:
    :noindex:

:mod:`~quantlib.termstructures.yields.flat_forward`
"""""""""""""""""""""""""""""""""""""""""""""""""""
.. automodule:: quantlib.termstructures.yields.flat_forward
    :members:
    :noindex:

:mod:`~quantlib.termstructures.yields.zero_curve`
"""""""""""""""""""""""""""""""""""""""""""""""""
.. automodule:: quantlib.termstructures.yields.zero_curve
    :members:
    :noindex:

:mod:`quantlib.termstructures.credit`
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

:mod:`~quantlib.termstructures.credit.default_probability_helpers`
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
.. automodule:: quantlib.termstructures.credit.default_probability_helpers
    :members:
    :noindex:

:mod:`~quantlib.termstructures.credit.piecewise_default_curve`
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
.. automodule:: quantlib.termstructures.credit.piecewise_default_curve
    :members:
    :noindex:

:mod:`~quantlib.termstructures.credit.flat_hazard_rate`
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
.. automodule:: quantlib.termstructures.credit.flat_hazard_rate
    :members:
    :noindex:

:mod:`~quantlib.termstructures.credit.interpolated_hazardrate_curve`
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
.. automodule:: quantlib.termstructures.credit.interpolated_hazardrate_curve
    :members:
    :noindex:

:mod:`quantlib.time`
--------------------

:mod:`quantlib.time.date`
^^^^^^^^^^^^^^^^^^^^^^^^^
.. automodule:: quantlib.time.date
    :members:
    :undoc-members:
    :noindex:
.. autodata::

:mod:`quantlib.time.calendar`
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. automodule:: quantlib.time.calendar
    :members:
    :noindex:

.. autoclass:: TARGET
    :noindex:

:mod:`quantlib.time.daycounter`
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. automodule:: quantlib.time.daycounter
   :members:
   :noindex:

:mod:`quantlib.time.daycounters`
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

:mod:`~quantlib.time.daycounters.simple`
""""""""""""""""""""""""""""""""""""""""
.. automodule:: quantlib.time.daycounters.simple
   :members:
   :undoc-members:
   :noindex:

:mod:`~quantlib.time.daycounters.thirty360`
"""""""""""""""""""""""""""""""""""""""""""
.. automodule:: quantlib.time.daycounters.thirty360
   :members:
   :noindex:

:mod:`quantlib.time.schedule`
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. automodule:: quantlib.time.schedule
    :members:
    :noindex:
