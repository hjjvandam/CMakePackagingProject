.. _advanced_building-label:

Advanced Building
=================

While CPP strives to make building a project easy, power users and developers
will likely want more control over the project they are building.

Toolchains
----------

While not strictly necessary, it is worth pointing out that CMake supports the
usage of a toolchain file.  These files are forwarded to CMake via the
``CMAKE_TOOLCHAIN_FILE`` variable.  Particularly when you are setting a lot of
options for CMake these files can come in handy.  Basically they look like:

.. code-block:: cmake

   set(OPTION1 VALUE1)
   set(OPTION2 VALUE2)


That is they're just a large number of CMake ``set`` commands.  Internally CPP
uses a toolchain file to forward options to dependencies.  This file is located
at ``build/directory/toolchain.cmake``.  Running CMake on a CPP project with no
arguments is a great way to generate a template toolchain file.
