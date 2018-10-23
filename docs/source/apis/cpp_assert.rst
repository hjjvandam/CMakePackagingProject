.. _cpp_assert-label:

cpp_assert Module
=================

The ``cpp_assert`` module provides functions that facilitate asserting that a
critical condition is met and if that condition is not met, aborting the run.
Functions from this module play a critical role in unit testing of CPP as well
as ensuring that input logic is not invalidated.  Like the ``cpp_checks`` module
this module helps avoid common CMake gotchas and functions within this module
should be preferred over raw if statements while developing CPP.

.. __cpp_assert_true-label:

_cpp_assert_true/_cpp_assert_false
----------------------------------

``_cpp_assert_true`` aborts the configuration if any of the identifiers contain
a false value.  ``_cpp_assert_false`` aborts the configuration if any of the
identifiers contain a true value.  For the purposes of these two functions note
that true and false follow CMake's true/false rules, which are available
`here <https://cmake.org/cmake/help/latest/command/if.html>`_.

.. function:: _cpp_assert_true([var1 [var2 [...]]])

   :param var: The identifiers to check for their truthfulness.

.. function:: _cpp_assert_false([<var1> [<var2> [...]]])

   :param var: The identifiers to check for their falseness.

.. __cpp_assert_equal-label:

_cpp_assert_equal/_cpp_assert_not_equal
---------------------------------------

These functions compare two values and aborts if the values do not compare equal
(in the case of ``_cpp_assert_equal``) or if the values compare equal (in the
case of ``_cpp_assert_not_equal``).  Equality is defined as string equality,
*i.e.*, we cast both values to strings and then compare them.

.. function:: _cpp_assert_equal(<lhs> <rhs>)

   :param lhs: The value "on the left" of the equality comparison
   :param rhs: The value "on the right" of the equality comparison

.. function:: _cpp_assert_not_equal(<lhs> <rhs>)

   :param lhs: The value "on the left" of the inequality comparison
   :param rhs: The value "on the right" of the inequality comparison.


.. __cpp_assert_exists-label:

_cpp_assert_exists/_cpp_assert_does_not_exist
---------------------------------------------

These functions can be used to abort the configuration if a path doesn't exist
(for the ``_cpp_assert_exists`` version) or if a path does exist (for the
``_cpp_assert_does_not_exist`` variant).  In all cases the check does not care
if the resulting path points to a file, directory, or symbolic link, simply that
there is some filesystem entity with that path.

.. function:: _cpp_assert_exists(<path>)

   :param path: The path to check for existence.

.. function:: _cpp_assert_does_not_exist(<path>)

   :param path: The path to check for existence.

.. __cpp_assert_contains-label:

_cpp_assert_contains/_cpp_assert_does_not_contain
-------------------------------------------------

CMake natively has the ability to check if a string contains a substring, but
it's a bit awkward to use in practice.  The functions in this section wrap the
native functionality additionally aborting the configuration if the substring is
not found (for ``_cpp_assert_contains``) or if it is found (for
``_cpp_assert_does_not_contain``).

.. function:: _cpp_assert_contains(<substring> <string>)

   :param substring: The substring that we are looking for.
   :param string: The string which is supposed to contain the substring.

.. function:: _cpp_assert_does_not_contain(<substring> <string>)

   :param substring: The substring that should not appear.
   :param string: The string which should not contain the substring.

.. __cpp_assert_file_contains-label:

_cpp_assert_file_contains/_cpp_assert_file_does_not_contain
-----------------------------------------------------------

``_cpp_assert_file_contains`` and ``_cpp_assert_file_does_not_contain`` are
thin wrappers around ``_cpp_assert_contains`` and
``_cpp_assert_does_not_contain`` respectively.  In both cases the functions read
the contents of the file into a buffer that is passed to the corresponding
subfunction.

.. function:: _cpp_assert_file_contains(<substring> <path>)

   :param substring: The substring to search for.
   :param path: The path to the file we are searching.

.. function:: _cpp_assert_file_does_not_contain(<substring> <path>)

   :param substring: The substring to search for.
   :param path: The path to the file we are searching.
