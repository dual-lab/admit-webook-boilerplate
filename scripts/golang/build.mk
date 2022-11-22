# ============================================================================ #
#
#  Author       : dmike
#  Date         : 02 Febrary 2020
#  Description  : This is a specific plugin from golang language. Iterates over
#  				all the source file building the relative object files.
#
# ============================================================================ #

ldflags :=

PHONY:= __build
__build: __init_build

quiet_cmd_init_build = $(call LOG,$(INFO),== Go build in $(marker))
color_cmd_init_build = $(c_cyang)$(quiet_cmd_init_build)
cmd_init_build =

PHONY += __init_build
__init_build:
	$(call cmd,init_build)

quiet_cmd_end_build = $(call LOG,$(INFO),== Go build out $(marker))
color_cmd_end_build = $(c_cyang)$(quiet_cmd_end_build)
cmd_end_build =

PHONY += go_build_target
__build : go_build_target

go_target := $(addprefix $(target_root)/,$(project_name))
go_build_target: $(go_target)
	$(call cmd ,end_build)

include $(root)/scripts/golang/_build_object.mk

ifneq ($(strip $(ldflags)),$(empty))
ldflags := -ldflags=$(ldflags)
endif

mod_file := $(root)/go.mod

quiet_cmd_out = OUT	$@
color_cmd_out = $(c_green)$(quiet_cmd_out)
cmd_out = $(GO) build $(ldflags) -o $@ $<
$(go_target): $(main) $(mod_file) $(go_build_objects) $(dirs_built_in)
	$(call cmd,out)

quiet_cmd_gomod = GO MOD	$(mod_name)
color_cmd_gomod = $(c_magenta)$(quiet_cmd_gomod)
cmd_gomod = $(GO) mod init $(mod_name)
$(mod_file):
	$(call cmd,gomod)

.PHONY: $(PHONY)