from setuptools import find_packages, setup, Extension


from Cython.Distutils import build_ext
from Cython.Build import cythonize
from Cython.Tempita import Template

import numpy
from pathlib import Path
DEBUG = False

SUPPORT_CODE_INCLUDE = './cpp_layer'

QL_LIBRARY = 'QuantLib'

INCLUDE_DIRS = ['/usr/local/include', '/usr/include', numpy.get_include(), "."]
LIBRARY_DIRS = ['/usr/local/lib', '/usr/lib']

CYTHON_DIRECTIVES = {"embedsignature": True,
                     "language_level": '3',
                     "auto_pickle": False}

def render_templates():
    paths = [
        (Path("quantlib/termstructures/yields"), ["piecewise_yield_curve", "discount_curve", "forward_curve", "zero_curve"]),
        (Path("quantlib"), ["handle"]),
    ]
    for p, names in paths:
        for basename in names:
            for ext in (".pxd", ".pyx"):
                output = (p / basename).with_suffix(ext)
                fname = output.with_suffix(f"{ext}.in")
                if not output.exists() or (output.stat().st_mtime < fname.stat().st_mtime):
                    template = Template.from_filename(fname, encoding="utf-8")
                    with output.open("wt") as f:
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
        package_data = {"": ["**.pxd", "types.pxi", "cpp_layer/observable.hpp"]},
        packages=find_packages(include=["quantlib*"]),
        ext_modules = collect_extensions(),
        cmdclass = {'build_ext': pyql_build_ext},
        zip_safe = False
    )
