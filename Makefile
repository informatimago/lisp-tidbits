LINE='========================================================================'
all test run clean:
	@for dir in $$(find * -prune -type d -print ) ; do \
		echo $(LINE) ;\
		$(MAKE) -w -C $$dir $(MAKEFLAGS) $(MFLAGS) $@ ;\
	done
	@echo $(LINE)
