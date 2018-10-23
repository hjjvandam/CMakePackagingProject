.. _cpp_toolchain-label:

cpp_toolchain Module
====================

The ``cpp_toolchain`` module contains functions related to writing and
manipulating the toolchain file.

.. _cpp_get_toolchain_vars-label:

_cpp_get_toolchain_vars
-----------------------

.. function:: _cpp_get_toolchain_vars(<return>)

   Ultimately we will be concerned with a long list of variables that get
   written to the toolchain file.  In order to avoid having this list in
   numerous places (and therefore increasing the likely hood of someone
   forgetting to update one of those places) we have created this function.
   Basically you give it an identifier it gives you the list of variables we
   look for.

   :param return: An identifier to assign the list to.


.. _cpp_write_toolchain_file-label:

_cpp_write_toolchain_file
-------------------------

.. function:: _cpp_write_toolchain_file([DESTINATION <destination>])

    This function will create a file *toolchain.cmake* that is suitable for use
    as a CMake toolchain file.  The contents of the file are populated by
    reading standard CMake variables.

    :param destination: The full path to the directory where the toolchain file
        should be installed.  Defaults to ``CMAKE_BINARY_DIR``

    CMake variables used:

    * CMAKE_BINARY_DIR (Only used if destination is not specified)
    * CMAKE_C_COMPILER
    * CMAKE_CXX_COMPILER
    * CMAKE_Fortran_COMPILER
    * CMAKE_SYSTEM_NAME
    * CMAKE_MODULE_PATH
    * BUILD_SHARED_LIBS
    * CMAKE_SHARED_LIBRARY_PREFIX
    * CMAKE_SHARED_LIBRARY_SUFFIX
    * CMAKE_STATIC_LIBRARY_PREFIX
    * CMAKE_STATIC_LIBRARY_SUFFIX
    * CPP_LOCAL_CACHE
