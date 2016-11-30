MakeBS
======

*MakeBS* is a flexible build system for UNIX development environments.

Requirements
------------

* [POSIX.1 shell and utilities](http://pubs.opengroup.org/onlinepubs/9699919799/idx/xcu.html)
    * *c99* must support the `-M` extension as exposed by [GCC](https://gcc.gnu.org/) and [clang](http://clang.llvm.org/)
    * *make* must support pattern matching expressions as planned for *the Open Group Base Specification Issue 8*

Getting MakeBS
--------------

Version control for *MakeBS* is handled with [Git](http://git-scm.com/). The following command clones its repository:

    git clone https://github.com/Boobies/makebs.git

Alternatively, [GitHub](https://github.com/) provides [an archive of the master branch](https://github.com/Boobies/makebs/archive/master.zip).

Usage
-----

In order to build a project with *MakeBS*, the build system must reside in a subdirectory called `makebs`. The project's root directory should contain a
wrapper makefile that may define macros, may contain rules, and must include `makebs/makebs.mk`. The wrapper makefile is project-specific and should be used as
*make*'s input.

### Project Directory Structure

* `bin`: Executable files
* `include`: Header files
* `lib`: Library files
* `makebs`: Build system
    * `dep`: Source code dependencies
* `obj`: Object files
* `src`: Source code

### Targets

The following targets are supported:

* `all`: Builds everything
* `makebs_obj`: Compiles source code
* `makebs_lib`: Builds libraries
* `makebs_bin`: Builds programs
* `clean`: Removes dependency and output directories
* `install`: Installs headers, libraries, and/or programs

By default, the `install` target will attempt to install **everything** in `/usr/local/` but the wrapper makefile may change this (see the examples below).

### Examples

The following example snippets are intended to document the build system's features. Note the **order** in which things are written:

1. File macro definitions
2. *MakeBS* makefile inclusion
3. Install macro definition and target rules

#### Building a Library

##### makefile

    FOOBAR_SRC_FILES = foo.c bar.c
    FOOBAR_OBJ_FILES = $(FOOBAR_SRC_FILES:.c=.o)
    FOOBAR_LIB_FILE = libfoobar.a

    SRC_FILES += $(FOOBAR_SRC_FILES)
    LIB_FILES += $(FOOBAR_LIB_FILE)

    include makebs/makebs.mk

    INSTALL = $(INC_DIR) $(LIB_DIR)

    $(LIB_DIR)/$(FOOBAR_LIB_FILE): $(FOOBAR_OBJ_FILES:%=$(OBJ_DIR)/%) | $(LIB_DIR)
    	$(AR) $(ARFLAGS) $@ $?

#### Building a Program

##### makefile

    FOOBAR_SRC_FILES = foo.c bar.c
    FOOBAR_OBJ_FILES = $(FOOBAR_SRC_FILES:.c=.o)
    FOOBAR_LIB_FILES = libbaz.a
    FOOBAR_BIN_FILE = foobar.out

    SRC_FILES += $(FOOBAR_SRC_FILES)
    BIN_FILES += $(FOOBAR_BIN_FILE)

    include makebs/makebs.mk

    INSTALL = $(BIN_DIR)

    $(BIN_DIR)/$(FOOBAR_BIN_FILE): $(FOOBAR_OBJ_FILES:%=$(OBJ_DIR)/%) $(FOOBAR_LIB_FILES:%=$(LIB_DIR)/%) | $(BIN_DIR)
    	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(FOOBAR_OBJ_FILES:%=$(OBJ_DIR)/%) -L $(LIB_DIR) $(FOOBAR_LIB_FILES:lib%.a=-l %)

License
-------

*MakeBS* is free software licensed under the terms and conditions of the *GNU Lesser General Public License*. For more details, see the `COPYING` and
`COPYING.LESSER` files.

