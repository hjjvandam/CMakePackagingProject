.. _cpp_checks-label:

cpp_checks Module
=================

The ``cpp_checks`` module provides functions that facilitate determining if
various conditions have been met.  Developers of CPP are strongly encouraged to
use the checks within this module so as to avoid many of the plethora of
gotchas associated with CMake's if statements.


.. _cpp_is_defined-label:

_cpp_is_defined/_cpp_is_not_defined
-----------------------------------

These functions can together be used to check whether or not a variable has been
defined.  CMake defines a variable as being defined if ``set`` has been called
on it.  It therefore does not matter if the variable holds the empty string, it
is still defined.

.. function:: _cpp_is_defined(<return> <var>)

   :param return: The identifier to which the return should be assigned.
   :param var: The identifier to check.

.. function:: _cpp_is_not_defined(<return> <var>)

   :param return: The identifier to assign the return to.
   :param var: The identifier to check.

Example Usage:
^^^^^^^^^^^^^^

.. code-block:: cmake

   _cpp_is_defined(is_defined NOT_A_VARIABLE)
   if(is_defined)
        message("NOT_A_VARIABLE is defined")
   else()
        message("NOT_A_VARIABLE is not defined")
   endif()

.. _is_empty-label:

_cpp_is_empty/_cpp_is_not_empty
-------------------------------

A variable is empty if the value it holds compares equal to the empty string.
Thus setting a variable to the empty string will make it empty, but so will not
defining the variable, or not initializing the variable.

.. function:: _cpp_is_empty(<return> <var>)

   :param return: The identifier to which the return should be assigned.
   :param var: The identifier to check.

.. function:: _cpp_is_not_empty(<return> <var>)

   :param return: The identifier to assign the return value to.
   :param var: The identifier to check.


Example Usage:
^^^^^^^^^^^^^^

.. code-block:: cmake

        set(A_VARIABLE "")
        _cpp_is_empty(is_empty A_VARIABLE)
        if(is_empty)
            #Do stuff knowing A_VARIABLE is empty
        endif()


.. _cpp_contains-label:

_cpp_contains/_cpp_does_not_contain
-----------------------------------

These functions wrap CMake's native string parsing functions to facilitate
determining whether or not a substring is contained within a string.

.. function:: _cpp_contains(<return> <substring> <str>)

   :param return: The identifier to save the return value to.
   :param substring: The value of the substring to look for.
   :param str: The value of the string to search

Example Usage:
^^^^^^^^^^^^^^

.. code-block:: cmake

   _cpp_contains(is_contained "Hello" "Hello World")
   if(is_contained)
        #Do stuff knowing "Hello" is in the string.
   endif()

.. _cpp_xor-label:

_cpp_xor
--------

.. function:: _cpp_xor(<return> [<var1> [<var2> [...]]])

   The xor function implements an exclusively or check on a series of
   identifiers.  In other words, this function will check to see if one, and
   only one, of the variables provided to it is true.  If more than one is
   true, or all of them are false this function returns false.  This function
   does not tell you which variable is true because in practice this function is
   used to make sure the user didn't specify conflicting options.

   :param return: The identifier to contain the output result.
   :param var: The identifiers to check for the xor condition.

Example Usage:
^^^^^^^^^^^^^^

.. code-block:: cmake

   set(a_false_variable FALSE)
   set(a_true_variable TRUE)
   _cpp_xor(only_1_true a_false_variable a_true_variable)
   if(only_1_true)
        #Do stuff knowing that only one of the variables is set to true
   endif()
