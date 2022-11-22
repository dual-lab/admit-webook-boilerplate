# ############################################################################ #
#
#  Author       : dmike
#  Date         : 26,May 2019
#  Description  : Install plugin. Implement the logic of install the project.
#	The default target (_install) depends on leanguage specific install plugin,
# named language/install.mk
#
# ############################################################################ #
PHONY := _install
_install:

PHONY += install
_install : install

install : makeinstall = $(debug)$(MAKE) -f $(root)/scripts/$@/install.mk marker=$(obj)
install : $(type)

$(type):
	$(makeinstall)

.PHONY : $(PHONY)
