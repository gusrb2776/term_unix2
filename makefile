# A sample Makefile for building Google Test and using it in user
# tests.  Please tweak it to suit your environment and project.  You
# may want to move it to your project's root directory.
#
# SYNOPSIS:
#
#   make [all]  - makes everything.
#   make TARGET - makes the given target.
#   make clean  - removes all files generated by make.

# Please tweak the following variable definitions as needed by your
# project, except GTEST_HEADERS, which you can use in your own targets
# but shouldn't modify.

# Points to the root of Google Test, relative to where this file is.
# Remember to tweak this if you move this file.
GTEST_DIR=googletest/googletest

# Where to find user code.
USER_DIR=.
TEST_DIR=tests
LIB_DIR=libs
OBJ_DIR=objs
SRC_DIR=src
EXEC_DIR=bin
BUILD_DIR=build
INCLUDE_DIR=include

# Flags passed to the preprocessor.
# Set Google Test's header directory as a system directory, such that
# the compiler doesn't generate warnings in Google Test headers.
CPPFLAGS += -isystem $(GTEST_DIR)/include

# Flags passed to the C++ compiler.
CXXFLAGS += -g -Wall -Wextra -pthread

# All tests produced by this Makefile.  Remember to add new tests you
# created to the list.

TESTS  = test_player
SRCS  := $(wildcard $(TEST_DIR)/*.cpp)
HEADERS := $(wildcard $(INCLUDE_DIR)/*.h)
LIBS  := $(wildcard $(LIB_DIR)/*.c)
OBJS  := $(LIBS:$(LIB_DIR)/%.c=$(BUILD_DIR)/$(OBJ_DIR)/%.o) 
#$(SRCS:$(TEST_DIR)/%.c=$(BUILD_DIR)/$(OBJ_DIR)/%.o)
EXECS := $(SRCS:$(TEST_DIR)/%.cpp=$(BUILD_DIR)/$(EXEC_DIR)/%)

BUILD_SUB_DIR := $(OBJ_DIR) $(EXEC_DIR)
MAKE_DIR := $(BUILD_DIR) $(BUILD_SUB_DIR:%=$(BUILD_DIR)/%)

$(info SRCS $(SRCS) LIBS $(LIBS))
$(info OBJS $(OBJS) EXECS $(EXECS))
$(info MAKE_DIR $(MAKE_DIR) HEADERS $(HEADERS))

# All Google Test headers.  Usually you shouldn't change this
# definition.
GTEST_HEADERS = $(GTEST_DIR)/include/gtest/*.h \
                $(GTEST_DIR)/include/gtest/internal/*.h

# House-keeping build targets.

all : build_dir $(EXECS)

clean :
	rm -rf $(EXECS) gtest.a gtest_main.a *.o $(BUILD_DIR)

test :
	$(EXECS)

# Builds gtest.a and gtest_main.a.

# Usually you shouldn't tweak such internal variables, indicated by a
# trailing _.
GTEST_SRCS_ = $(GTEST_DIR)/src/*.cc $(GTEST_DIR)/src/*.h $(GTEST_HEADERS)

# For simplicity and to avoid depending on Google Test's
# implementation details, the dependencies specified below are
# conservative and not optimized.  This is fine as Google Test
# compiles fast and for ordinary users its source rarely changes.
gtest-all.o : $(GTEST_SRCS_)
	$(CXX) $(CPPFLAGS) -I$(GTEST_DIR) $(CXXFLAGS) -c \
            $(GTEST_DIR)/src/gtest-all.cc

gtest_main.o : $(GTEST_SRCS_)
	$(CXX) $(CPPFLAGS) -I$(GTEST_DIR) $(CXXFLAGS) -c \
            $(GTEST_DIR)/src/gtest_main.cc

gtest.a : gtest-all.o
	$(AR) $(ARFLAGS) $@ $^

$(BUILD_DIR)/$(OBJ_DIR)/gtest_main.a : gtest-all.o gtest_main.o
	$(AR) $(ARFLAGS) $@ $^

# Builds a sample test.  A test should link with either gtest.a or
# gtest_main.a, depending on whether it defines its own main()
# function.

$(BUILD_DIR)/$(OBJ_DIR)/%.o : $(LIB_DIR)/%.c
	$(CXX) $(CPPFLAGS) -I$(INCLUDE_DIR) $(CXXFLAGS) -c $^ -o $@

$(SRC_DIR)/%.o : $(SRC_DIR)/%.c $(GTEST_HEADERS) 
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@

build_dir : |$(MAKE_DIR)

$(MAKE_DIR):
	mkdir -p $(MAKE_DIR)

$(EXECS) : $(SRCS) $(OBJS) $(HEADERS) gtest-all.o#$(BUILD_DIR)/$(OBJ_DIR)/gtest_main.a
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -I$(INCLUDE_DIR) -lpthread $^ -o $@
