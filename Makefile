build:
	python setup.py build_ext --inplace -j 4

docs:
	make -C docs html

install:
	pip install .

uninstall:
	pip uninstall quantlib

tests: build
	python -m unittest discover -v

clean:
	find quantlib -name \*.so -exec rm {} +
	find quantlib -name \*.pyc -exec rm {} +
	find quantlib -path quantlib/cpp_layer -prune -o -name \*.cpp -exec rm {} +
	find quantlib -name \*.c -exec rm {} +
	find quantlib -name \*.h -exec rm {} +
	-rm quantlib/termstructures/yields/{piecewise_yield_curve,discount_curve,forward_curve,zero_curve}.{pxd,pyx}
	rm -rf build
	rm -rf dist

.PHONY: build docs clean
