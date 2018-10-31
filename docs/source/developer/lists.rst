.. _lists-label:

Forwarding Lists
================

The reality is users can provide CPP with lists as input.  It is CPP's job to
respect those lists and make sure they get forwarded correctly.  This page will
explain in agonizing detail why this is so much more of a pain than it sounds.

The Problem
-----------

A typical scenario is that the user has things installed in multiple places and
needs to provide multiple paths to the ``CMAKE_PREFIX_PATH`` variable.  At the
command line they do:

.. code-block:: bash

   cmake -DCMAKE_PREFIX_PATH="path1;path2;path3"

and within CMake ``CMAKE_PREFIX_PATH`` is now set to a three item list.
Basically when CMake encounters a semicolon in a string it treats it as a list
separator and swallows it.  For most CMake usages this is a detail and proper
usage of quotes avoids any problems.  Particularly for CPP we run into problem
when we need to write lists.

A lot of CPP works by writing ``CMakeLists.txt`` on the fly.  Inevitably we need
to write lists to those files.  Let's say we're calling ``_cpp_run_sub_build``
in a very simple manner:

.. code-block:: cmake

   set(A_LIST one two three)
   _cpp_run_sub_build(
       ...
       CONTENTS "set(A_LIST ${A_LIST})"

where we've elided the irrelevant parts of the call.  So what happens?  Inside
``_cpp_run_sub_build`` all of the arguments to ``CONTENTS`` get concatenated
into a variable
