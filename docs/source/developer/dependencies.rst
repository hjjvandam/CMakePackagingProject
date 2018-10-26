.. dev_dependencies-label:

CPP's Dependency Strategy
=========================

The purpose of this page is to document the strategy for internally handling
dependencies with CPP.

Finding Dependencies
--------------------

From the perspective of CPP this is trivial.  Either the dependency is ideal and
provides a config file or there needs to be a find recipe available.  Either way
we're not responsible for this part.  What we're responsible for is the order in
which we look for the dependency.

Ultimately we want the end-user to be able to have the final say about which
installed version of a dependency is used.  Thus the first thing we do is check
if the user set ``${name}_ROOT``.  Note that ``${name}`` should evaluate to the
name of the dependency as ``find_package`` would look for it (*i.e.*, in
whatever case the name usually is in).  Anyways, if the user has set the
``${name}_ROOT`` variable we look for a config file under that path (and only
under that path).  If we can't find it we then punt and try to find it with a
find recipe.  Unfortunately, there's no way for us to limit the paths a find
recipe uses.  If we still can't find the dependency we abort as the user's
path was obviously bad.

If the user did not set ``${name}_ROOT`` then we look for the config file in the
list of paths given by the CMake (or environment) variables:

* CMAKE_PREFIX_PATH
* CMAKE_FRAMEWORK_PATH
* CMAKE_APPBUNDLE_PATH

if that returns nothing we check CPP's dependency cache.  If that's still a bust
we look in the usual places for that system, *i.e.*, the contents of:

* CMAKE_SYSTEM_PREFIX_PATH
* CMAKE_SYSTEM_FRAMEWORK_PATH
* CMAKE_SYSTEM_APPBUNDLE_PATH

If after all that we still can't find a config file we attempt to use a find
recipe to find the dependency (again we can't control the paths used within a
find recipe).  If that also fails, then we give up.

Building Dependencies
---------------------

Regardless of how the source is obtained, or whether the user provides with a
build recipe or not, dependencies are built using build recipes.  Build recipes
are nothing more than the literal CMake commands required to build the
dependency.  Typically these commands involve a call to CMake's
``ExternalProject_Add`` command (documentation is `here
<https://cmake.org/cmake/help/latest/module/ExternalProject.html>`_).  Note that
``ExternalProject_Add`` command runs at build time, and not during the configure
phase, which means the dependency will not be ready at build time.  To
circumvent this, all build recipes are executed by a sub CMake command
during the configure phase.

The use of build recipes encapsulates CPP from the details of the build.  It
also provides a convenient record of how the dependency was built.  All
buildable dependencies are added to CPP via the
:ref:`cpp_find_or_build_dependency-label` command.  Thus one of the first steps
of this command is to generate the build recipe.


Installing the Dependency
-------------------------

This is probably the hardest part of the whole process.  Basically after we
build a dependency we need to put it someplace so that we can find it again.
While simple in concept realize that the dependency's lifetime can be tied to
the main project's lifetime.  More specifically, unless the dependency is
consumed during the build phase (things like header-only libraries, or static
libraries) the project will need its dependencies the next time it is used.
Furthermore consumers of our project may also directly depend on those
dependencies.  This latter point is far easier to explain with an example.

Say project A depends on some library B and say another project C depends on
both A and B.  Importantly assume that C does not depend on B purely through
A (*i.e.*, C uses some of B's functionality directly).  The result depends on
whether A and C use the same or different versions of B, and whether A and C
link statically or dynamically to B.  It's very easy for this result to behave
unexpectedly, both to the build system and from within the code.  In this
example, the burden for handling B correctly ultimately resides with C.  More
generally it is always the responsibility of the top of the software stack to
handle the dependencies lower than it.  Since the top of one's software stack
is the middle of someone else's stack, this is better stated as each component
needs to manage the dependencies lower than it while remaining cognisant of the
fact that it may not be the top of the stack.

That was a somewhat long segue, but the point is how we install the dependencies
has consequences for the remainder of the software stack and thus we need to do
it in an intelligent way.  Here's our strategy.  We define a directory called
the CPP cache, or "cache" for short. Inside the cache we have a directory for
each project that uses CPP.  Inside the project directory is a directory for
each version of that project.  Inside each version directory is a directory for
each configuration.  Finally, within the configuration directory is an install
tree for that project.

The next install consideration is the ``xxx-config.cmake`` file so that the
project and its dependencies can be found correctly.  Of those two requirements
finding the project is the easiest since it's location is known relative to the
config file.  Finding the dependencies is harder.  The reason this is harder is
we need to reconstruct the ``cpp_find_or_build_dependency`` command inside
the configuration file.  Easiest way to do this is to cheat.  As we build the
dependency we know where we put it.  We just record that path and set
``<dependency>_ROOT`` in the config file before calling ``find_dependency``. To
record this value we make a dummy target ``_cpp_<dependency>_interface`` and
slap the value on the ``INTERFACE_VERSION`` property.



Example
-------

How does this play out in practice?  Consider our above example, starting
with the assumption that both A and C use CPP and that we are not using
existing versions of any dependency (if a version exists then we just don't
build it, removing some of the recursion in the following examples). When a
user tries to build C, C will go look for A and B.  A and B will searched for in
the order they are listed. Let's say A is listed first.  Then CPP will build A
triggering a sub-CPP call. The subcall will look for B, and upon not finding it,
will build and cache it. A's dependencies are built, so the sub CPP call builds
A and caches it.  Control returns to the outer CPP call which then looks for
B, and finds the one built by A.  C's dependencies satisfied, C is then built
and cached.  If B is listed first, the CPP instance building C will build and
cache B.  Then a sub CPP call is made to build and cache A (which will use the
B built by the outer CPP call).  C's dependencies satisfied, C is built and
cached.

What if only C or A is managed by CPP.  Starting with only C, then CPP will look
for A, not find it, and build A.  CPP will then look for B if A works ideally it
will bring B into scope and C will avoid building it.  If only A is managed by
CPP.  Then A will rebuild B unless C provides it the necessary info (assuming C
built B first) or C will use the B built by A (assuming C uses
``find_package``).  If all of the packages use CPP it's the same as the case
when only A and C did, except building B triggers an additional sub-CPP call.
Finally, if none of the packages use CPP then it's not CPP's concern...
