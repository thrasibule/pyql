from setuptools import find_packages, setup, Extension


import os

from Cython.Distutils import build_ext
from Cython.Build import cythonize
from Cython.Tempita import Template

import numpy

DEBUG = False

SUPPORT_CODE_INCLUDE = './cpp_layer'

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

class pyql_build_ext(build_ext):
    """
    Custom build command for quantlib that on Windows copies the quantlib dll
    and optionally c runtime dlls to the quantlib package.
    """
    def build_extensions(self):
        build_ext.build_extensions(self)


if __name__ == '__main__':
    setup(
        name = 'quantlib',
        version = '0.1',
        author = 'Didrik Pinte,Patrick Henaff',
        license = 'BSD',
        package_data = {"": ["**.pxd", "types.pxi", "cpp_layer/observable.hpp"]},
        packages=find_packages(include=["quantlib*"]),
        ext_modules = collect_extensions(),
        cmdclass = {'build_ext': pyql_build_ext},
        install_requires = ['tabulate', 'pandas'],
        zip_safe = False
    )
