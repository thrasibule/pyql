import quantlib.currency.currencies
from quantlib.util.object_registry import ObjectRegistry

def initialize_currency_registry():

    registry = ObjectRegistry('Currency')

    for currency_cls in dir(quantlib.currency.currencies):
        if not currency_cls.startswith('__'):
            currency = getattr(quantlib.currency.currencies, currency_cls)()
            registry.register(currency.code, currency)

    return registry

REGISTRY = initialize_currency_registry()
currency_from_name = REGISTRY.from_name
