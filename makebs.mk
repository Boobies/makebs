# Copyright 2016 Bogdan Barbu
#
# This file is part of MakeBS.
#
# MakeBS is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# MakeBS is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with MakeBS.  If not, see <http://www.gnu.org/licenses/>.

# MakeBS subdirectory
MAKEBS_DIR = makebs

# Source directories
SRC_DIR = src
INC_DIR = include

# Dependency directory
SRCDEP_DIR = $(MAKEBS_DIR)/dep

# Output directories
OBJ_DIR = obj
LIB_DIR = lib
BIN_DIR = bin

# Dependency files
SRCDEP_FILES = $(SRC_FILES:.c=.d)

# Output files 
OBJ_FILES = $(SRC_FILES:.c=.o)

# Directories to install
INSTALL ?= $(INC_DIR) $(LIB_DIR) $(BIN_DIR)

.PHONY: all
all: makebs_obj makebs_lib makebs_bin

.PHONY: makebs_obj
makebs_obj: $(OBJ_FILES:%=$(OBJ_DIR)/%)

.PHONY: makebs_lib
makebs_lib: $(LIB_FILES:%=$(LIB_DIR)/%)

.PHONY: makebs_bin
makebs_bin: $(BIN_FILES:%=$(BIN_DIR)/%)

.PHONY: clean
clean: ; rm -rf $(SRCDEP_DIR) $(OBJ_DIR) $(LIB_DIR) $(BIN_DIR)

.PHONY: install
install: all; cp -R -i $(INSTALL) /usr/local/

# Create any missing directories
$(SRCDEP_DIR) $(OBJ_DIR) $(LIB_DIR) $(BIN_DIR): ; mkdir -p $@

# Pattern rule for auto-dependency generation
$(SRCDEP_DIR)/%.d: $(SRC_DIR)/%.c | $(SRCDEP_DIR)
	@printf '$(OBJ_DIR)/' >$@
	$(CC) $(CFLAGS) -MM $< -I $(INC_DIR) >>$@

# Use the dependency files
-include $(SRCDEP_FILES:%=$(SRCDEP_DIR)/%)

# Pattern rule for object files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c -o $@ $< -I $(INC_DIR)

