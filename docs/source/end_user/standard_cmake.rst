.. _standard_cmake-label:

CMake Option Variables
======================

This page collects CMake variables that can be used as options to the
CMake command to control the resulting build.  Projects are strongly encouraged
to use these variables when relevant and under no circumstance should a
project override any of these variables.

Standard CMake Variables
------------------------

These are variables that are defined by CMake itself and therefore should be
honored by all projects using CMake regardless of whether or not they used CPP.
Note that the inopportune word there is **should**; you'll find a plethora of
counterexamples...

CMAKE_XXX_COMPILER
^^^^^^^^^^^^^^^^^^

Here ``XXX`` can be ``CXX``, ``C``, or ``Fortran``.  This variable can be used
to specify the compiler for language ``XXX``.  It is strongly recommended that
you use full paths otherwise weirdness can occur if the environment changes.

CMAKE_XXX_FLAGS
^^^^^^^^^^^^^^^

Again ``XXX`` can be ``CXX``, ``C``, or ``Fortran``.  This variable can be used
to hold a list of flags that should be given to the ``XXX`` compiler.

CMAKE_TOOLCHAIN_FILE
^^^^^^^^^^^^^^^^^^^^

Used to point to the toolchain file.  CPP will automatically forward the
toolchain file to dependencies.

CMAKE_INSTALL_PREFIX
^^^^^^^^^^^^^^^^^^^^

This is the directory to use as the root of the installation.  This defaults to
something like ``/usr/local`` on Unix-like operating systems.

CMAKE_PREFIX_PATH
^^^^^^^^^^^^^^^^^

This is a list of paths that CMake should search in order to locate a package.
Of note you will likely need to set this variable to the location of CPP when
compiling a project that relies on CPP (unless you install CPP system-wide).

BUILD_SHARED_LIBRARIES
^^^^^^^^^^^^^^^^^^^^^^

This can be used to control whether or not libraries are shared or static.

XXX_ROOT
^^^^^^^^

Many of the old ``FindXXX.cmake`` modules used such variables as hints for
where a dependency ``XXX`` is installed.  CMake has now adopted such variables
as part of the standard and ``find_package`` automatically considers such
variables as hints, regardless of whether the module recognizes the variable or
not.

CPP Specific Variables
----------------------

CPP_GITHUB_TOKEN
^^^^^^^^^^^^^^^^

Used to authenticate the user for a private GitHub repository.  The value of
this variable should be set to the token.  The token needs to be generated to
minimally have read access to the repository.
