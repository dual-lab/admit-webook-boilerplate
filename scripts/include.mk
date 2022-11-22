# ============================================================================ #
#
#  Author       : dmike
#  Date         : 2,October 2016
#  Description  : Make beutiful things
#
# ============================================================================ #

# ============================================================================ #
#
# Variable comma,empty,space and squote
#
# ============================================================================ #
comma := ,
empty :=
squote:= '
space := $(empty) $(empty) #End of line
# ============================================================================ #
#
# Error function and variable.
#
# ============================================================================ #
ERROR   := [ERROR]
INFO    := [INFO]
WARNING := [WARN]
LOG     = $(1)$(space)$(2)
# ============================================================================ #
#
# Error code.
#
# ============================================================================ #
E001_NO_LANGUAGE := Fatal error no language specified. Declare al least one language.
# ============================================================================ #
#
# Function to escape quote character
# Usage: $(call escsq, text)
#
# ============================================================================ #
escsq = $(subst $(squote),'\$(squote)',$(1))
# ============================================================================ #
#
# Terminal Color Variable
#
# ============================================================================ #
c_reset      := \033[0m
c_red        := \033[1;91m
c_blue       := \033[34m
c_cyang      := \033[36m
c_magenta    := \033[35m
c_yellow     := \033[33m
c_green      := \033[32m
c_black      := \033[30m
# ============================================================================ #
#
# Echo mode:
#	-silent_  (no echo)
#	-quiet_   (no shell command)*
#   -color_   (quiet + color)
#	-verbose_ (All command)
#ps. (*): default mode
# ============================================================================ #
kecho        := :
quiet_kecho   = printf  '$(1)\n';
silent_kecho  = :
color_kecho   = printf '$(1)$(c_reset)\n';

echo-cmd = $(if $($(mode)cmd_$(1)),\
	$(call $(mode)kecho,$(call escsq,$($(mode)cmd_$(1)))))
cmd = $(debug)$(echo-cmd) $(cmd_$(1))
# ============================================================================ #
#
# Function to check file existence
# Usage: $(call file-exists,text)
#
# ============================================================================ #
file-exists = $(wildcard $(1))
# ============================================================================ #
#
# Function tha call the  relative leanguage specifications'  build  plugin
# Usage : $(call makebuild src,type)
#
# ============================================================================ #
makebuild = $(debug)$(MAKE) -f $(root)/scripts/build.mk obj=$(1) type=$(2)
# ============================================================================ #
# Function that call the relative specific language install plugin
# Usage : $(call makeinstall src,type) 
# ============================================================================ #
makeinstall = $(debug)$(MAKE) -f $(root)/scripts/install.mk obj=$(1) type=$(2)
# ============================================================================ #
#
# Function tha call the  relative leanguage specifications'  clean plugin
# Usage : $(call makeclean src,type)
#
# ============================================================================ #
makeclean = $(debug)$(MAKE) -f $(root)/scripts/clean.mk obj=$(1) type=$(2)
# ============================================================================ #
#
# Function that call the  relative leanguage specifications'  clobber  plugin
# Usage : $(call makeclobber src,type)
#
# ============================================================================ #
makeclobber = $(debug)$(MAKE) -f $(root)/scripts/clobber.mk obj=$(1) type=$(2)
# ============================================================================ #
#
# Function that fill the sub makefile with project dependencies
#
# ============================================================================ #
makedep = $(debug)echo '\#Automatic Generated' >> $(2)/Makefile
# ============================================================================ #
#
# Function that call the kernel make file
#
# ============================================================================ #
makekernel = $(debug)$(MAKE) -C $(1) M=$(2) $(3)
# ============================================================================ #
#
# Remove command.
# Usage : $(call cmd,rm)
#
# ============================================================================ #
quiet_cmd_rm = RM	$@
color_cmd_rm = $(c_red)$(quiet_cmd_rm)
cmd_rm = $(RM) -rf $@
# ============================================================================ #
#
# Mkdir command.
# Usage : $(call cmd,mkdir)
#
# ============================================================================ #
quiet_cmd_mkdir = MKDIR    $@
color_cmd_mkdir = $(c_cyang)$(quiet_cmd_mkdir)
cmd_mkdir = $(MKDIR) -p $@
# ============================================================================ #
# command to autogenerate prerequisities deps
# ============================================================================ #
define GENPRE = 
set -e;  $(RM) -f $@ ; \
$(CC) -MM $(cflags) $< > $@.$$$$; \
sed 's,\($*\)\.o[ :]*,$(out_dir)/\1.o $@ : ,g' < $@.$$$$ > $@; \
$(RM) -f $@.$$$$
endef
quiet_cmd_gen = GEN	$@
color_cmd_gen = $(c_blue)$(quiet_cmd_gen)
cmd_gen = $(GENPRE)
