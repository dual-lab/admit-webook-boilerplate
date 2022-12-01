# ============================================================================ #
#
#  Author       : dmike
#  Date         : 02 Febrary 2020
#  Description  : create object files
#
# ============================================================================ #
# ============================================================================ #
# Initialize local variables
# This variables are read from include Makefile
# ============================================================================ #
src :=
main :=
dirs:=
libs:=
inp_dir:= $(marker)
out_dir:= $(addsuffix $(marker:$(src_root)%=%),$(target_root))

PHONY:= __internal_build
__internal_build:
# ============================================================================ #
# Include, if present, local makefile in which are defined the files and the
# directories contained in the upmost dir:
#   src  -> all source files
#   main -> source of the main package
#   dirs -> all directories
#   libs -> all static libs
#   deps -> possible project dependencies
# ============================================================================ #
include $(inp_dir)/Makefile
# ============================================================================ #
# Include utilities function
# ============================================================================ #
include $(root)/scripts/include.mk
# ============================================================================ #
# Format and sort inclued objects
# ============================================================================ #
obj_in := $(addprefix $(out_dir)/,$(notdir $(marker)))
go_build_objects:= $(addsuffix .o, $(obj_in))
dirs_built_in:=

ifneq ($(strip $(dirs)),$(empty))
dirs := $(sort $(patsubst %/,%,$(dirs)))
dirs_built_in += $(addprefix $(out_dir)/,$(dirs))
endif

__internal_build : $(go_build_objects) $(dirs_built_in)


# ============================================================================ #
# Static pattern rule to create object file
# ============================================================================ #
quiet_cmd_go = GO $@
color_cmd_go = $(c_yellow)$(quiet_cmd_go)
cmd_go = $(GO) build -o $@ $^
inp_stem := $(addprefix $(inp_dir)/,$(src))
$(go_build_objects) : $(inp_stem)
	$(call cmd,go)

# ============================================================================ #
# Static patter rule for sub object.o files
# ============================================================================ #
$(dirs_built_in): $(out_dir)/% : %
	@:

$(dirs_built_in): mkbuild = $(debug)$(MAKE) -f $(root)/scripts/golang/_build_object.mk marker=$(addprefix $(marker)/,$@)

# ============================================================================ #
# Recursive subdirs walk
# ============================================================================ #
PHONY += $(dirs)
$(dirs): out_sub_dir = $(addprefix $(out_dir)/,$@)

$(dirs):
	$(if $(call file-exists,$(out_sub_dir)),,$(MKDIR) -p $(out_sub_dir))
	$(mkbuild)

.PHONY: $(PHONY)
