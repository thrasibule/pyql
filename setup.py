from setuptools import find_packages, setup, Extension


import os

from Cython.Build import cythonize
from Cython.Tempita import Template

import numpy

QL_LIBRARY = 'QuantLib'

INCLUDE_DIRS = ['/usr/local/include', '/usr/include', numpy.get_include(), "."]
LIBRARY_DIRS = ['/usr/local/lib', '/usr/lib']

CYTHON_DIRECTIVES = {"embedsignature": True,
                     "language_level": '3',
                     "auto_pickle": False}

def render_templates():
    for basename in ["piecewise_yield_curve", "discount_curve", "forward_curve", "zero_curve"]:
        for ext in ("pxd", "pyx"):
            fname = f"quantlib/termstructures/yields/{basename}.{ext}.in"
            output = fname[:-3]
            if not os.path.exists(output) or (os.stat(output).st_mtime < os.stat(fname).st_mtime):
                template = Template.from_filename(fname, encoding="utf-8")
                with open(output, "wt") as f:
                    f.write(template.substitute())

def collect_extensions():
    """ Collect all the directories with Cython extensions and return the list
    of Extension.

    Th function combines static Extension declaration and calls to cythonize
    to build the list of extensions.
    """

    kwargs = {
        'language':'c++',
        'include_dirs':INCLUDE_DIRS,
        'library_dirs':LIBRARY_DIRS,
        'extra_link_args': ['-Wl,--strip-all'],
        'libraries':[QL_LIBRARY]
    }

    render_templates()

    collected_extensions = cythonize(
            Extension('*', ["quantlib/**/*.pyx"], **kwargs),
            exclude="test",
            compiler_directives=CYTHON_DIRECTIVES, nthreads = 4)

    return collected_extensions

if __name__ == '__main__':
    setup(
        package_data = {"": ["**.pxd", "types.pxi", "cpp_layer/observable.hpp"]},
        packages=find_packages(include=["quantlib*"]),
        ext_modules = collect_extensions(),
        zip_safe = False
    )
