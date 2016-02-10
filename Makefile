#  Makefile in PLUGINS/SearchTac

MODULES :=  src/search_plugin.ml4 src/SearchTac.v test-suite/example1.v test-suite/example2.v
ROOT := ./
.PHONY: coq clean

coq: Makefile.coq
	$(MAKE) -f Makefile.coq

Makefile.coq: Makefile $(MODULES)
	coq_makefile -R $(ROOT)/src Search \
		     $(MODULES) -o Makefile.coq
	# here adding some dependencies that the Makefile does not seem able to figure out
	echo >>Makefile.coq
	echo \# Added dependencies at `date` >>Makefile.coq
	echo src/SearchTac.vo src/SearchTac.glob :  src/search_plugin.cmxs >> Makefile.coq

clean:: Makefile.coq
	$(MAKE) -f Makefile.coq clean
	rm -f Makefile.coq .depend
