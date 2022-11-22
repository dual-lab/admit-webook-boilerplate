# ============================================================================ #
#
#  Author       : dmike
#  Date         : 18,March 2017
#  Description  : Clean plugin. Implement the logic of clean recipe.
#	The default target (_clean) depends on leanguage specific clean plugin,
# named language/clean.mk
#
# ============================================================================ #
PHONY := _clean
_clean:

PHONY += clean
_clean: clean

clean : makeclean = $(debug)$(MAKE) -f $(root)/scripts/$@/clean.mk marker=$(obj)
clean : $(type)

$(type):
	$(makeclean)

.PHONY : $(PHONY)
