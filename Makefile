wheel:
	python -m build --wheel -n -C--global-option=build_ext -C--global-option=-j6

build:
	python setup.py build_ext --inplace -j 8

docs:
	make -C docs html

install:
	pip install . -C--global-option=build_ext -C--global-option=-j6

uninstall:
	pip uninstall quantlib

tests: build
	python -m unittest discover -v

clean:
	find quantlib -name \*.so -exec rm {} +
	find quantlib -name \*.pyc -exec rm {} +
	find quantlib -name \*.cpp -exec rm {} +
	find quantlib -name \*.c -exec rm {} +
	find quantlib -name \*.h -exec rm {} +
	-rm quantlib/termstructures/yields/{piecewise_yield_curve,discount_curve,forward_curve,zero_curve}.{pxd,pyx}
	rm -rf build
	rm -rf dist

.PHONY: build docs clean
