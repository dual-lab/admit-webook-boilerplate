#!/usr/bin/make -f
# ============================================================================ #
#
#  Author       : dmike
#  Date         : 2,October 2016
#  Description  : Principal Makefile
#
# ============================================================================ #

# ============================================================================ #
#
# Make flag.
# Scope:
#	- do not use built-in rules
#	- do not use built-in variables
#	- do not print working directories
#
# ============================================================================ #
MAKEFLAGS += -rR --no-print-directory -s
# ============================================================================ #
#
# Default target of principal Makefile
#
# ============================================================================ #
PHONY := _all
_all:
# ============================================================================ #
#
# Delete implicit rules on top Makefile
#
# ============================================================================ #
$(CURDIR)/Makefile Makefile: ;
# ============================================================================ #
#
# Default target dependencies
#
# ============================================================================ #
PHONY += all
_all: all
# ============================================================================ #
#
# Define the root dir of the project
#
# ============================================================================ #
root	:= $(if $(KBUILD_SRC),$(KBUILD_SRC),$(CURDIR))
export root
# ============================================================================ #
#
# Include some useful function and variable. The definition is in
#	$(src_root)/scripts/include.mk
#
# ============================================================================ #
$(root)/scripts/include.mk: ;
include $(root)/scripts/include.mk
# ============================================================================ #
#
# Define the project structure. The default is:
#
#	src: -->Source code		target: --> Compiled object
#		main:               	   main:
#			<language_name>             <language_name>
#		test:                      test:
#			<language_name>            <language_name>
#
# This structure can be customized defing the following variable in the KBUILD
# file:
#	languages:
#   src_root:
#	dep_root:
#	target_root
# ============================================================================ #
$(root)/KBUILD: ;
include $(root)/KBUILD
# ============================================================================ #
#
# Variable debug. Default deactivated to improve output. if you want active
# it, set to and empty value in KBUILD file.
#
# ============================================================================ #
debug ?= @
# ============================================================================ #
#
# Variable mode. Default to quiet. No command shown. if you want you can set to:
#  1- color_ to show color ouput
#  2- empty string to deactive  output
# This variable can be set in the KBUILD file.
# ============================================================================ #
mode ?= quiet_
export debug mode
# ============================================================================ #
install_language ?= $(empty)
languages ?= $(empty)
ifeq ($(languages),$(empty))
 $(error $(call LOG,$(ERROR),$(E001_NO_LANGUAGE)))
endif
project_name ?= $(notdir $(patsubst %/,%,$(root)))
src_root ?= $(root)/src
dep_root ?= $(root)/dep
target_root ?= $(root)/build

VPATH = $(src_root)
export project_name src_root dep_root\
 target_root MAKECMDGOALS\
 VPATH
# ============================================================================ #
#
# Extract the main languages from the ones defined in KBUILD.
#
# ============================================================================ #
language_main := $(filter-out %/,$(languages))
dirs := $(src_root) \
  $(target_root) \
  $(dep_root)

 $(dirs):
	$(call cmd,mkdir)
	$(call makedep,$(empty),$@)

PHONY += all_dirs
all_dirs : $(filter-out $(empty), $(dirs))
# ============================================================================ #
#
# Define the init recipe in order to initialize the
# project.After initialization an empty file '.initialize' is created in order to
# indicate that the project structure is ready.
#
# ============================================================================ #
init_flag := .initialize
quiet_cmd_init = $(call LOG,$(INFO),Init the project)
color_cmd_init = $(c_magenta)$(quiet_cmd_init)
cmd_init = touch $(init_flag)
$(init_flag) :
	$(call cmd,init)
PHONY += init
init: | $(init_flag) all_dirs;
# ============================================================================ #
#
# Define the build target in order to compile
# all the project.
#
# ============================================================================ #
PHONY += build
all: init build
build : $(language_main)

$(language_main):
	$(call makebuild,$(src_root),$@)
# ============================================================================ #
# Define the install target, should depend from the build target
# ============================================================================ #
ifneq ($(install_language),$(empty))
PHONY += install
install : build
	$(call makeinstall,$(src_root),$(install_language))

endif
# ============================================================================ #
#
# Define the clean recipe in order to clean
# all the project. There are two clean modality:
#  - clobber   : delete all the file compiled plus the bin files
#				+ all files listed in clobber_files variables.
#				+ all target directories
#  - clean     : delete all the file compiled
#				+ all files listed in clean_files variables.
#
# ============================================================================ #
PHONY += clean
language_clean := $(addprefix clean_,$(language_main))

# ============================================================================ #
#
# Clean specific variable: in particular defines the output command to
# signals when clean is completed.
#
# ============================================================================ #
clean : quiet_cmd_clean = $(call LOG,$(INFO),Clean complete)
clean : color_cmd_clean = $(c_green)$(quiet_cmd_clean)
clean : cmd_clean =
# ============================================================================ #
#
# Clean recipe depends on the type of languages imported from KBUILD file
# and on clean_files imported from KBUILD file too.
#
# ============================================================================ #
clean : $(language_clean) $(clean_files)
	$(call cmd,clean)
# ============================================================================ #
#
# Call recursively the clean plugin of the specific language
#
# ============================================================================ #
$(language_clean):
	$(call makeclean,$(src_root),$(patsubst clean_%,%,$@))
$(clean_files):
	$(call cmd,rm)

PHONY += clobber
language_clobber := $(addprefix clobber_,$(language_main))
# ============================================================================ #
#
# Clobber specific variable: in particular defines the output command to
# signals when clean is completed.
# (**) at end of the recipe the target root directory will be removed.
#
# ============================================================================ #
clobber : quiet_cmd_clobber = $(call LOG,$(INFO),Clobber complete)
clobber : color_cmd_clobber = $(c_green)$(quiet_cmd_clobber)
clobber : cmd_clobber = rm -rf $(target_root)
# ============================================================================ #
#
# Clobber recipe depends on the type of languages imported from KBUILD file
# and on clobber_files imported from KBUILD file too.
#
# ============================================================================ #
clobber : $(language_clobber) $(clobber_files)
	$(call cmd,clobber)
# ============================================================================ #
#
# Call recursively the clean plugin of the specific language
#
# ============================================================================ #
$(language_clobber):
	$(call makeclobber,$(src_root),$(patsubst clobber_%,%,$@))
$(clobber_files):
	$(call cmd,rm)
# ============================================================================ #
#
# Print last project git version
#
# ============================================================================ #
PHONY += version

version : quiet_cmd_version = $(call LOG,$(INFO),Last version)
version : color_cmd_version = $(c_magenta)$(quiet_cmd_version)
version : cmd_version = $(GIT) describe --tags --always --match=v*

version:
	$(call cmd,version)

.PHONY : $(PHONY)
