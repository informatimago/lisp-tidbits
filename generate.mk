all::$(ALL_PROGRAMS)

run::$(ALL_PROGRAMS)
	@for p in $(ALL_PROGRAMS) ; do printf "%-20s: %s\n" "$$p"  "$$($(RUN_ENV) ./$$p)" ; done

test::$(ALL_PROGRAMS)
	@for p in $(ALL_PROGRAMS) ; do printf "%-20s: %s\n" "$$p"  "$$($(RUN_ENV) ./$$p)" ; done
	@ls -l $(ALL_PROGRAMS)

clean::
	-rm -f *.o *.fas *.lib *.log *.hi *.[dl]x{32,64}fsl *.fasl
	-rm -f ../*.fas ../*.lib ../*.log
	-rm -f $(ALL_PROGRAMS)

ECL_INCS=-I/opt/local/include
ECL_LIBS=-L/opt/local/lib -lecl
RUN_ENV=DYLD_LIBRARY_PATH=/opt/local/lib:$(DYLD_LIBRARY_PATH) LD_LIBRARY_PATH=/opt/local/lib:$(LD_LIBRARY_PATH)

FPC=fpc
CLISP=clisp
CCL=ccl
ECL=ecl
SBCL=sbcl
CC=cc
HASKELL=ghc

LINE="//----------------------------------------------------------------------"
HERE=$(shell pwd)

define compile
	@echo "$2" >  $1
	@$2        >> $1 2>&1 || cat $1
endef

.PHONY: all test run clean

%-c:%.c
	@printf "// Generating Executable from %s source: %s\n" "C" $@
	$(call compile,$@.log,$(CC) -o $@ $<)

%-c-static:%.c
	@printf "// Generating Static Executable from %s source: %s\n" "C" $@
	$(call compile,$@.log,$(CC) -static -o $@ $<)

%-pascal:%.pas
	@printf "// Generating Executable from %s source: %s\n" "Pascal" $@
	$(call compile,$@.log,$(FPC) -o$@ $<)

%-lisp-ccl:generate-%.lisp
	@printf "// Generating Executable from %s source: %s\n" "Lisp" $@
	-@rm -rf ~/.cache/common-lisp/ccl-*$(HERE)
	$(call compile,$@.log,$(CCL) -n < $<)
	@mv $* $@

%-lisp-clisp:generate-%.lisp
	@printf "// Generating Executable from %s source: %s\n" "Lisp" $@
	-@rm -rf ~/.cache/common-lisp/clisp-*$(HERE)
	$(call compile,%-lisp-clisp.log,$(CLISP) -norc < $<)
	@mv $* $@

%-lisp-clisp-fas:%.fas ../clisp-fas-rt.fas 
	@printf "// Generating Executable from %s source: %s\n" "Lisp" $@
	@(echo '#!/usr/local/bin/clisp -norc -ansi -q -E utf-8' ;\
	  cat $^ ../clisp-fas-rt.fas ) > $@
	@chmod 755 $@

../clisp-fas-rt.fas:../clisp-fas-rt.lisp
	@printf "// Compiling: %s\n" $@
	$(call compile,$@.log,$(CLISP) -ansi -q -E utf-8 -norc -c $< -o $@)

%.fas:%.lisp
	@printf "// Compiling: %s\n" $@
	$(call compile,$@.log,$(CLISP) -ansi -q -E utf-8 -norc -c $< -o $@)

%-lisp-ecl:generate-%.lisp
	@printf "// Generating Executable from %s source: %s\n" "Lisp" $@
	-@rm -rf ~/.cache/common-lisp/ecl-*$(HERE)
	$(call compile,$@.log,$(ECL) -norc < $<)
	@mv $* $@

%-lisp-sbcl:generate-%.lisp
	@printf "// Generating Executable from %s source: %s\n" "Lisp" $@
	-@rm -rf ~/.cache/common-lisp/sbcl-*$(HERE)
	$(call compile,%-lisp-sbcl.log,$(SBCL) --no-userinit < $<)
	@mv $* $@

%-ecl:%-ecl.c
	@printf "// Generating Executable from %s source: %s\n" "C using libecl" $@
	$(call compile,$@.log,$(CC) -o $@ $< $(ECL_INCS) $(ECL_LIBS))

%-haskell:%.hs
	@printf "// Generating Executable from %s source: %s\n" "Haskell" $@
	-@rm -f *.o
	$(call compile,$@.log,$(HASKELL) $<)
	@mv $* $@

