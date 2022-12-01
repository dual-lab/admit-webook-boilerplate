# ############################################################################ #
#
#  Author       : dmike
#  Date         : 18,March 2017
#  Description  : Clobber plugin. Implement the logic of clean all the project
#	The default target (_clobber) depends on on leanguage specific clobber plugin,
# named language/clobber.mk
#
# ############################################################################ #
PHONY := _clobber
_clobber:

PHONY += clobber
_clobber: clobber

clobber : makeclobber = $(debug)$(MAKE) -f $(root)/scripts/$@/clobber.mk marker=$(obj)
clobber : $(type)

$(type):
	$(makeclobber)


.PHONY : $(PHONY)
