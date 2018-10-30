.. _cpp_dependency-label:

cpp_dependency Module
=====================

These are functions related to finding and building a dependency.

.. _cpp_find_dependency-label:

cpp_find_dependency
-------------------

.. function:: cpp_find_dependency(NAME <name> [REQUIRED]\
                                  [VERSION <version>] \
                                  [RESULT <was_found>] \
                                  [PATHS <path1> [<path2> [...]]])

   This function is a wrapper over CMake's ``find_package`` that sanitizes the
   process and simplifies it from the user's perspective.  Basically we
   recognize two scenarios: the user has a very specific installation in mind
   and wants us to use that, or we're supposed to find it somewhere on the
   system.  The first scenario requires the user to set the value of the
   ``<name>_ROOT`` variable to point to the install location of the package.
   The second scenario looks in a predefined set of paths to find the package.
   Consult :ref:`dev-dependencies-label` for the exact process used by CPP (as
   well as the specific paths searched).

   Like ``find_package`` itself, users may specify ``REQUIRED`` to force
   configuration to abort if a suitable version of the package is not located.
   Failure also occurs if the user provides a ``<name>_ROOT`` variable, but the
   package can not be located using that path.

   :param name: The name of the dependency to locate.
   :param version: The minimum version of the package required.
   :param was_found: An identifier to hold whether the dependency was found.
   :param path: A list of paths that should be considered in addition to those
                in ``CMAKE_PREFIX_PATH``

   :CMake Variables:

      * **<name>_ROOT** - Used to specify a particular installation of the
        dependency to use.
      * CMake variables used by ``find_package`` (should document)


.. _cpp_find_or_build_dependency-label:

cpp_find_or_build_dependency
----------------------------

.. function:: cpp_find_or_build_dependency(\
                  <name> (RECIPE <recipe> || \
                          PATH <path>     || \
                          URL <url> [PRIVATE] [BRANCH <branch>])

   This function attempts to make it easy for a user of CPP to add a dependency
   that can optionally be built by CPP if it is not found.  It requires two
   pieces of information: the name of the dependency and a mechanism for
   building the dependency.  At the moment three mechanisms are recognized:
   downloading the source, using source that is locally available on the
   machine, or using a build recipe.  The latter is a catch-all that can be used
   when the build process is not "ideal".  These mechanisms are mutually
   exclusive and an error will be raised if you try to mix them in the same
   call.

   Specifying the keyword ``URL`` triggers the download mechanism.  This is the
   preferred mechanism for obtaining a dependency.

   :param name: The name of the dependency.
   :param recipe: The path to the build recipe to use.
   :param path: The path to the root of the source tree.
   :param url: The URL to use to download the source.
   :param branch: The branch of the repository to use.
   :param imp: A list of implementations for a particular virtual dependency.

   CMake variables used:

   * CMAKE_BINARY_DIR - For storing build recipes we generate on the fly.

.. _cpp_record_find-label:

_cpp_record_find
----------------

.. function:: _cpp_record_find(NAME <name> \
                               [VERSION <version>])

   This function records the ``cpp_find_dependency`` call to a target
   ``_cpp_<name>_interface`` via that target's ``VERSION`` property so that it
   can be repeated in the ``<name>-config.cmake`` file.  Note that
   ``find_dependency`` takes additional arguments that are not concerned with
   the specification of what constitutes a suitable variant of a dependency.

   :param name: The name of the dependency.
   :param version: The required version of the dependency.

.. _cpp_get_gh_url-label:

_cpp_get_gh_url
---------------

.. function:: _cpp_get_gh_url(<return> URL <url> \
                              [BRANCH <branch>] \
                              [PRIVATE])

   This function encapsulates the logic for GitHub's HTML-based API.  The input
   is the base URL of the form ``github.com/<organization>/<repo>`` and the
   output will be the URL to use to download a tarball of the source.  The user
   may optionally include the ``https:`` and/or the ``www.`` and this function
   will still work.  FWIW, the GitHub HTML-based API works like:

   .. code-block:: html

      https://api.github.com/repos/<organization>/<repo>/tarball/<branch>

   where ``<organization>`` is the user or organization on GitHub, ``<repo>`` is
   the name of the repo, and ``<branch>`` is either a named branch or a commit.
   If ``PRIVATE`` is specified, then this function will use the GitHub token
   present in ``CPP_GITHUB_TOKEN`` to clone the repo.

   This function will crash if a URL is not specified or if that URL does not
   contain the literal string ``github.com``.  It also will crash if ``PRIVATE``
   is specified, but ``CPP_GITHUB_TOKEN`` is not set.

   :param return: The identifier to save the resulting URL to.
   :param url: The URL the user provided that will be parsed.
   :param branch: The name of the branch to retrieve.  Defaults to master.

   :CMake Variables:

      * **CPP_GITHUB_TOKEN** - Used to provide a GitHub token to access the
        private repository.  The token is only used for private repos.


.. _cpp_get_source_tarball-label:

_cpp_get_source_tarball
-----------------------

.. function:: _cpp_get_source_tarball(<output_file>
                                      (URL <url> [BRANCH <branch>] [PRIVATE] ||\
                                       SOURCE_DIR <dir>))

   This function encapsulates the process of getting an archive containing the
   source code, regardless of that source's origin.  In particular we allow for
   two points of origin: a local directory or a URL.  It is assumed that the
   URL directly downloads a tarball.

   :param output_file: The path to where the tarball should reside (including
      the name of the tarball).
   :param url: The url to download the file from.
   :param branch: The branch to use (if url is GitHub)
   :param dir: The directory containing the source.

   :CMake Variables:

       * **CPP_GITHUB_TOKEN** - If a URL to a private GitHub repository is
         provided the token in this variable will be used to obtain the source.

.. _cpp_get_remote_dependency-label:

.. _cpp_untar_directory-label:

_cpp_untar_directory
--------------------

.. function:: _cpp_untar_directory(<tar_file> <destination>)

   Given a tarball, this function will untar it and rename the resulting
   directory.  This function will err if the tarball:

   * does not exist,
   * is empty,
   * contains 1 object and  that object is not a directory, or
   * contains more than 1 objects.


   :param tar_file: The path to the tarball.
   :param destination: What the directory should be renamed to.

.. _cpp_build_local_dependency-label:

_cpp_build_local_dependency
---------------------------

.. function:: _cpp_build_local_dependency(NAME <name> \
                                          SOURCE_DIR <src> \
                                          INSTALL_DIR <install> \
                                          [TOOLCHAIN <toolchain>] \
                                          [BINARY_DIR <bin>])

   Given a local source directory this function will run CMake on it, build the
   resulting project, and install it.  The source directory is expected to be a
   ready-to-go CMake-based project.  The function itself is implemented as a
   thin wrapper around :ref:`cpp_run_sub_build-label` and supplies the
   boilerplate necessary to wrap the project in an ``ExternalProject_Add`` call.

   As a developer note, the ``ExternalProject_Add`` command could go away if we
   always assume that the project is CMake-based (then ``_cpp_run_sub_build`` is
   basically the same thing). Where ``ExternalProject_Add`` helps us is if the
   project is not CMake-based.  Then it provides an API that can be used to
   wrap the non-CMake-based project in a CMake-like API.

   :param name: The name of the dependency.
   :param src: The path to the root of the dependency's source tree.
   :param install: The path where the dependency should be installed.
   :param toolchain: The toolchain to use for building the dependency.
   :param bin: The directory where the build files should live.

   :CMake Variables:

       * **CMAKE_TOOLCHAIN_FILE** - Used to get the default toolchain.
       * **CMAKE_BINARY_DIR** - Used to get the default directory for

.. _cpp_depend_install_path-label:

_cpp_depend_install_path
------------------------

.. function:: _cpp_depend_install_path(<return> \
                                       NAME <name> \
                                       SOURCE_DIR <path> \
                                       [CPP_CACHE <cache>] \
                                       [TOOLCHAIN <file>] \
                                       [BINARY_DIR <dir>])

    For a given dependency this function will generate the path for installing
    it.  The resulting path is a function of the dependency's name, the source
    code for the dependency, and the configuration (*i.e.*, the toolchain). We
    use the source code as a more accurate representation of the version (let's
    face it, most projects are not going to update the CMake files after every
    commit).

   :param return: An identifier to use for the returned path.
   :param name: The name of the dependency.
   :param path: The path to the dependency's source code.
   :param cache: The path to the CPP cache where we will install the dependency.
   :param file: The path to the toolchain file.
   :param dir: A scratch directory where a tarball can be placed (needed to hash
       the source code).

   :CMake Variables:

       * **CPP_INSTALL_CACHE** - Used for the default path to the Cache
       * **CMAKE_TOOLCHAIN_FILE** - Used for the default path to the toolchain
       * **CMAKE_BINARY_DIR** - Used for the default output location for the
         source tarball
