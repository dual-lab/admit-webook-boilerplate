# ============================================================================ #
#
#  Author       : dmike
#  Date         : 02 Febrary 2020
#  Description  : This is a specific plugin from golang language.
#
# ============================================================================ 

# ============================================================================ #
# Default target
# ============================================================================ #
PHONY := go_clobber
go_clobber:

include $(root)/scripts/golang/clean.mk
# ============================================================================ #
# Define begin and end clobber command
# ============================================================================ #
quiet_cmd_init_clobber = $(call LOG,$(INFO),== Go Clobber in $(marker))
color_cmd_init_clobber = $(c_cyang)$(quiet_cmd_init_clobber)
cmd_init_clobber =
quiet_cmd_end_clobber = $(call LOG,$(INFO),== Go Clobber out $(marker))
color_cmd_end_clobber = $(c_cyang)$(quiet_cmd_end_clobber)
cmd_end_clobber =
# ============================================================================ #
# Init target
# ============================================================================ #
PHONY += __go_clobber_init
go_clobber : __go_clobber_init go_clean clean_go_cache
	$(call cmd,end_clobber)

__go_clobber_init:
	$(call cmd,init_clobber)

PHONY += clean_go_cache

clean_go_cache: $(clobber_files)

quiet_cmd_goclean = $(call LOG,$(INFO),== Go clean in $(marker))
color_cmd_goclean = $(c_red)$(quiet_cmd_init_clobber)
cmd_goclean = $(GO) clean -r -cache -testcache $(mod_name)/$@

PHONY += $(clobber_files)

$(clobber_files):
	$(call cmd,goclean)

.PHONY : $(PHONY)