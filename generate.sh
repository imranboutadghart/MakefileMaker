#!/bin/bash

# variables to be changed depending on the project
HEADER_DIR="."
NAME="output"

# Find all .c and .cpp files recursively
C_SOURCES=$(find . -type f -name "*.c")
CPP_SOURCES=$(find . -type f -name "*.cpp")

# Create the Makefile
{
  echo "CC = gcc"
  echo "CXX = g++"
  echo "CFLAGS =   -I$HEADER_DIR -Wall -Wextra -Werror -g"
  echo "CXXFLAGS = -I$HEADER_DIR -Wall -Wextra -Werror -g"
  echo ""
  echo "TARGET = $NAME"
  echo ""
  echo "BIN_DIR = bin"
  echo ""

  # List all source files
  echo -n "SRCS ="
  for src in $C_SOURCES $CPP_SOURCES; do
    echo -n " $src"
  done
  echo ""
  echo ""

  # Generate object files list
  echo -n "OBJS ="
  for src in $CPP_SOURCES; do
    obj="$(basename src .cpp).o"
    echo -n " $obj"
  done
  for src in $C_SOURCES; do
    obj="bin/$(basename $src .c).o"
    echo -n " $obj"
  done
  echo ""
  echo ""
  echo -n "vpath %.c "
  echo $(dirname $C_SOURCES 2> /dev/null) | tr ' ' '\n' | sort -u | tr '\n' ' '
  echo ""
  echo -n "vpath %.cpp "
  echo $(dirname $CPP_SOURCES 2> /dev/null) | tr ' ' '\n' | sort -u | tr '\n' ' '
  echo ""
  echo ""
  echo ".DEFAULT_GOAL := \$(NAME)"
  echo ""
  echo ""

  # Build rules
  echo "all: \$(TARGET)"
  echo ""

  echo "\$(TARGET): \$(OBJS)"
  echo -e "\t\$(CXX) -o \$@ \$^"
  echo ""

  echo "\$(BIN_DIR)/%.o: %.c | \$(BIN_DIR)"
  echo -e "\t\$(CC) \$(CFLAGS) -c -o \$@ \$<"
  echo ""

  echo "\$(BIN_DIR)/%.o: %.cpp | \$(BIN_DIR)"
  echo -e "\t\$(CXX) \$(CXXFLAGS) -c -o \$@ \$<"
  echo ""

  # Clean rule
  echo "clean:"
  echo -e "\trm -f \$(BIN_DIR) \$(TARGET)"
  echo ""
  echo "fclean: clean"
  echo -e "\trm -f \$(TARGET)"
  echo ""
  echo "re: fclean all"

  # BIN Directory rule
  echo "\$(BIN_DIR): "
  echo -e "\tmkdir -p \$(BIN_DIR)"
} > Makefile

echo "Makefile generated successfully."
