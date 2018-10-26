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
    as a CMake toolchain file.  ``_cpp_get_toolchain_var`` will be called to get
    the list of variables and the values of those variables will be used in the
    toolchain file.

    :param destination: The full path to the directory where the toolchain file
        should be installed.  Defaults to ``CMAKE_BINARY_DIR``

    :CMake Variables Used:

      All variables returned by ``_cpp_get_toolchain_var`` as well as:

      * CMAKE_BINARY_DIR
        Used to default the location of the resulting toolchain file.

.. _cpp_change_toolchain-label:

_cpp_change_toolchain
---------------------

.. function:: _cpp_change_toolchain([TOOLCHAIN <path>] \
                                    [VARIABLES <var1> <value1> \
                                              [<var2> <value2> [...]])

   This function wraps the modification of an already existing toolchain file.
   Note that the input to this function's ``VARIABLES`` keyword needs to be
   pairs where the first member of the pair is the identifier to change the
   value of and the second member is the value to change it to.

   :param path: The path to the toolchain file.  Defaults to the value of
     ``CMAKE_TOOLCHAIN_FILE``.
   :param var: The identifier of the variable to modify.
   :param value: The value to set the identifier to in the toolchain file.

   :CMake Variables Used:

     * CMAKE_TOOLCHAIN_FILE
       Used as the default for the toolchain file.
