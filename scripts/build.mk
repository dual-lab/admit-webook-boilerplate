# ############################################################################ #
#
#  Author       : dmike
#  Date         : 4,April 2017
#  Description  : Build plugin. Implement the logic of build  the project.
#	The default target (_buil) depends on leanguage specific build plugin,
# named language/build.mk
#
# ############################################################################ #
PHONY := _build
_build:

PHONY += build
_build : build

build : makebuild = $(debug)$(MAKE) -f $(root)/scripts/$@/build.mk marker=$(obj)
build: $(type)

$(type):
	$(makebuild)

.PHONY : $(PHONY)
