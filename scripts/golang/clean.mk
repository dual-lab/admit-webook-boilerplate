# ============================================================================ #
#
#  Author       : dmike
#  Date         : 02 Febrary 2020
#  Description  : This is a specific plugin from golang language. Clean all the
#  					object file.
#
# ============================================================================ #
#
# ============================================================================ #
# initialize used variables
# ============================================================================ #
src :=
dirs:=
clean_files:=
out_dir:= $(addsuffix $(marker:$(src_root)%=%),$(target_root))
# ============================================================================ #
# Default target
# ============================================================================ #
PHONY := go_clean
go_clean: mkclean = $(debug)$(MAKE) -f $(root)/scripts/golang/clean.mk marker=$@
# ============================================================================ #
# include utils variable
# ============================================================================ #
include $(root)/scripts/include.mk
# ============================================================================ #
# Include, if present, local makefile in which are defined the files and the
# directories contained in the upmost dir:
#   src -> all source files
#   dirs -> all directories
#   libs -> all lib directories
#   clean_files -> optional file to be removed during clean recipe
#   clobber_files -> optional file to be removed during clobber recipe
#   deps -> possible project dependencies
# ============================================================================ #
-include $(marker)/Makefile
obj_main := $(addsuffix .o,$(notdir $(marker)))
obj_main_clean:= $(clean_files)
obj_main_dirs := $(dirs)
obj_main_dirs += $(filter-out $(dirs),$(libs))
# ============================================================================ #
# Join all the objects necessary to the clean recipe
# ============================================================================ #
obj_src   := $(wildcard $(sort $(addprefix  $(out_dir)/,$(obj_main))))
obj_dir   := $(sort $(addprefix $(marker)/,$(obj_main_dirs)))
obj_clean := $(wildcard $(sort $(addprefix $(marker)/,$(obj_main_clean))))
# ============================================================================ #
# Define begin and end clean command
# ============================================================================ #
quiet_cmd_init_clean = $(call LOG,$(INFO),== Go Clean in $(marker))
color_cmd_init_clean = $(c_cyang)$(quiet_cmd_init_clean)
cmd_init_clean =
quiet_cmd_end_clean = $(call LOG,$(INFO),== Go Clean out $(marker))
color_cmd_end_clean = $(c_cyang)$(quiet_cmd_end_clean)
cmd_end_clean =
# ============================================================================ #
# Init target
# ============================================================================ #
PHONY += __go_clean_init
go_clean: __go_clean_init $(deps) $(obj_dir) $(obj_src) $(obj_clean)
	$(call cmd,end_clean)

__go_clean_init:
	$(call cmd,init_clean)

PHONY += $(obj_clean)
$(obj_clean):
	$(call cmd,rm)

PHONY += $(obj_src)
$(obj_src):
	$(call cmd,rm)

PHONY += $(obj_dir)
$(obj_dir):
	$(mkclean)

PHONY += $(deps)
$(deps):
	$(call makeclean,$@,$@)

.PHONY : $(PHONY)
