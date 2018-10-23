.. _quick_start-label:

Quick Start
===========

Projects using CPP are encouraged to use this page as their build documentation,
so if you're seeing this page odds are the package you're trying to build uses
CPP for their build.  Note we assume that all commands on this page are input
from the project's root directory.

Step 0: Get CMake
-----------------

CPP uses CMake so you're going to need CMake.  If you don't have CMake you
can probably get it from your package manager (*e.g.*, ``apt``,
``yum``, ...).  Otherwise the official site is `here <https://cmake.org/>`_.

Step 0.5: Get CPP
-----------------

Assuming you have CMake the next step is to get CPP.  CPP's official download
mirror is from our GitHub repo located
`here <https://github.com/CMakePackagingProject/CMakePackagingProject>`_.  Once
you obtain CPP's source it can be treated like any other CPP project so follow
Steps 1 and 2 to configure and build it.

Step 1: Configure Project
-------------------------

Unless the project you are trying to configure uses a newer version of CMake or
CPP you'll only have to do Steps 0 and 0.5 once.  For all other uses you'll
start here on Step 1.  Assuming the project you are building is located in the
directory ``root_dir``, change to that directory and run:

.. code-block:: bash

   cmake -H. -B<path/to/build/directory> [Options...]

The ``-H.`` simply tells CMake that the current directory is the root of the
project (it is possible to call CMake from a directory other than the root and
then compensate by modifying the path given to the ``-H`` flag; this is strongly
discouraged and is likely to break the configuration unless the package
maintainer is a CMake guru).  The ``-B`` flag is used to provide CMake a
directory for storing intermediate files.  This directory should be somewhere
that you have write permissions to.

Most packages will have many possible options.  Many of these options are
standard CMake variables, which are summarized on the page
:ref:`standard_cmake-label`.  It is strongly recommended that you peruse these
options before configuring so that you can control the build to your
satisfaction.  In addition to the standard options, packages may also define
additional options (usually to control the building of optional components).
Unfortunately such options are inherently package-dependent and it is the
responsibility of the package to inform you about these options (typically
such options can be discovered by reading the root ``CMakeLists.txt`` file
and looking for ``cpp_option`` if you're really curious).

.. note::
When a project uses CPP the configuration stage may take a long time. This is
because it is during this phase that CPP builds any dependencies that could not
be located.

Step 2: Build
-------------

After the project is configured you need to build it.  The preferred way to do
this is to run:

.. code-block:: bash

   cmake --build <path/to/build/directory>

where ``<path/to/build/directory>`` is the path you specified in Step 1.
Assuming there is actually something to build, CMake will show you progress
indicators as the build progresses.  If the command immediately returns it
usually means that the project has nothing to build (typically the case for
header-only libraries or projects like CPP that only install CMake modules).

Step 3: Install
---------------

Once building is done you can install the project.  The recommended way to do
this is:

.. code-block:: bash

   cmake --build <path/to/build/directory> --target install

Depending on where the package is to be installed you may need to run this
command with administrative privileges.





