OptErd
======

The code can be build with [Ninja build system](http://martine.github.io/ninja/). The script configure.py generate Ninja build file (build.ninja) which builds both the initial (FORTRAN) and the new (C) versions of ERD code, C interface, and tests.

Requirements
------------

* Python 2
* [Ninja build system](http://martine.github.io/ninja/)
* Intel Compiler
* Intel MPSS for MIC builds (including builds with MIC offload)

Configuration

To generate Ninja build files execute `./configure.py <uarch...>` where `<uarch...>` specify the target microarchitecture:

* `pnr` to configure build for Intel Penryn-generation processors
* `nhm` to configure build for Intel Nehalem/Westmere (recommended for Batman)
* `snb` to configure build for Intel Sandy Bridge
* `ivb` to configure build for Intel Ivy Bridge (use for CPU tuning for Endeavour, Stampede, Tianhe-2)
* `hsw` to configure build for Intel Haswell
* `pld` to configure build for AMD Piledriver
* `mic` to configure build for Intel MIC (native execution, **not** offload; use for MIC tuning)
* `nhm+mic` to configure build to Intel Nehalem/Westmere with code offload to MIC
* `snb+mic` to configure build to Intel Sandy Bridge with code offload to MIC
* `ivb+mic` to configure build to Intel Ivy Bridge with code offload to MIC (use for Endeavour, Stampede, Tianhe-2)
* `hsw+mic` to configure build to Intel Haswell with code offload to MIC

You may specify several microarchitectures, to build for several targets simultaneously.

Build
-----

After you configured the build, go to the root `OptErd` directory and run `ninja` to build the project. The static libraries will be built in `lib/<uarch>/` and the tests will go to `testprog/<uarch>`.

If you want to remove generated files, run `ninja -t clean` (**note**: usually it is not needed as Ninja tracks all dependencies between files, and if you change a C header, all source files that include will be recompiled automatically).

Changing options
----------------

If you want to temporarily change options, open `ninja.build` and change `CFLAGS = ...` to whatever you need. If you want to change options only for a particular microarchitecture, change `CC_<UARCH>` variable (e.g. `CC_IVB` to change only options for `ivb` configuration ro `CC_IVB_OFFLOAD` to change options for `ivb+mic` configuration).

If you want to permanently change options, change the lines in `configure.py` which set the respective options, and re-configure to update the Ninja build file. Commit your changes to `configure.py`,  but **do not commit your build.ninja file**.
