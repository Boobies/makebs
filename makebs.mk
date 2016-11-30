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
DBK_DIR = $(SRC_DIR)/docbook

# Dependency directories
SRCDEP_DIR = $(MAKEBS_DIR)/dep
DBKDEP_DIR = $(SRCDEP_DIR)/docbook

# Output directories
OBJ_DIR = obj
LIB_DIR = lib
BIN_DIR = bin
MAN_DIR = man
DOC_DIR ?= $(MAN_DIR)/man$(MAN_VOL)

# Dependency files
SRCDEP_FILES = $(SRC_FILES:.c=.d)
DBKDEP_FILES = $(DBK_FILES:.xml=.d)

# Documentation file extension
DOC_EXT ?= $(MAN_VOL)

# Output files 
OBJ_FILES = $(SRC_FILES:.c=.o)
DOC_FILES ?= $(DBK_FILES:.xml=.$(DOC_EXT))

# 3rd party
SAXON ?= /usr/share/java/Saxon-HE.jar
STYLESHEET ?= /usr/share/xml/docbook/stylesheet/docbook-xsl-ns/manpages/docbook.xsl

# Directories to install
INSTALL ?= $(INC_DIR) $(LIB_DIR) $(BIN_DIR) $(MAN_DIR)

.PHONY: all
all: makebs_obj makebs_lib makebs_bin makebs_doc

.PHONY: makebs_obj
makebs_obj: $(OBJ_FILES:%=$(OBJ_DIR)/%)

.PHONY: makebs_lib
makebs_lib: $(LIB_FILES:%=$(LIB_DIR)/%)

.PHONY: makebs_bin
makebs_bin: $(BIN_FILES:%=$(BIN_DIR)/%)

.PHONY: makebs_doc
makebs_doc: $(DOC_FILES:%=$(DOC_DIR)/%)

.PHONY: clean
clean: ; rm -rf $(SRCDEP_DIR) $(DBKDEP_DIR) $(OBJ_DIR) $(LIB_DIR) $(BIN_DIR) $(MAN_DIR) $(DOC_DIR)

.PHONY: install
install: all; cp -R -i $(INSTALL) /usr/local/

# Create any missing directories
$(SRCDEP_DIR) $(DBKDEP_DIR) $(OBJ_DIR) $(LIB_DIR) $(BIN_DIR) $(DOC_DIR): ; mkdir -p $@

# Pattern rules for auto-dependency generation

$(SRCDEP_DIR)/%.d: $(SRC_DIR)/%.c | $(SRCDEP_DIR)
	@printf '$(OBJ_DIR)/' >$@
	$(CC) $(CFLAGS) -MM $< -I $(INC_DIR) >>$@

$(DBKDEP_DIR)/%.d: $(DBK_DIR)/%.xml | $(DBKDEP_DIR)
	java -jar $(SAXON) -o:$@ $< $(MAKEBS_DIR)/dep.xsl
	@sed '1s:^:$(DBK_DIR)/:; 1s:\s: $(DBK_DIR)/:g; 2i\\ttouch $<' $@ >$*.tmp
	@mv -f $*.tmp $@

# Use the dependency files
-include $(SRCDEP_FILES:%=$(SRCDEP_DIR)/%)
-include $(DBKDEP_FILES:%=$(DBKDEP_DIR)/%)

# Pattern rules for object and documentation files

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c -o $@ $< -I $(INC_DIR)

$(DOC_DIR)/%.$(DOC_EXT): $(DBK_DIR)/%.xml | $(DOC_DIR)
	xsltproc -o $@ --xinclude $(STYLESHEET) $<

