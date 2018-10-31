.. _cpp_options-label:

cpp_options Module
==================

This module contains functions for manipulating build options as well as
facilitating the parsing/forwarding of function arguments.

.. _cpp_option-label:

cpp_option
----------

.. function:: cpp_option(<var> <default_value>)

    This function defines an identifier and a default value for that identifier.
    If when control reaches this function the identifier is already set, then
    this function will do nothing, *i.e.*, the identifier will keep its original
    value.  If, however, the identifier is not set, then this function will set
    the identifier to the provided default value.

   :param var:  The identifier to set the value of.
   :param default_value: The value to set the identifier to (if it's not set
       already)

Example Usage
^^^^^^^^^^^^^

.. code-block:: cmake

   option(BUILD_TESTS OFF)
   if(BUILD_TESTS)
       #Do stuff knowing the caller set BUILD_TESTS
   else()
       #Do stuff knowing that BUILD_TESTS has the default value
   endif()

.. _cpp_forward_list-label:

_cpp_forward_list
-----------------

.. function:: _cpp_forward_list(<return> <list>)

   For all intents and purposes CMake recognizes two types lists and not lists.
   In its infinite wisdom CMake decides that lists will be expressed as "not
   lists" with the items concatenated by semicolons.  Seems fine.  Here's where
   things get fun

   :param return: The identifier to assign the escaped list to.
   :param list: The list to escape.
