include configure.mk 

SERVLETS=parsereq response

BINARIES=$(foreach serv,$(SERVLETS),bin/lib$(serv).so)

LINKER=gcc
LDFLAGS:=$(LDFLAGS) -g -L$(PLUMBER_PREFIX)/lib -lpstd -lproto
CFLAGS:=$(CFLAGS) -g -I$(PLUMBER_PREFIX)/include/pstd -I$(PLUMBER_PREFIX)/include/proto

PARAM=LINKER="$(LINKER)" OUTPUT="../$(OUTPUT)" LDFLAGS="$(LDFLAGS)" CFLAGS="$(CFLAGS)"

default: $(BINARIES)

$(BINARIES): bin/lib%.so: % __always_build__ __check_environment__ $(OUTPUT)
	cd $< && make -f $(PLUMBER_PREFIX)/lib/plumber/servlet.mk $(PARAM)

$(OUTPUT):
	mkdir -p $(OUTPUT)

__always_build__:

__check_environment__:
	@if [ "x$(PLUMBER_PREFIX)" = "x" ]; then \
		echo "You should build the example in the Plumber Isolated Environment, see the init script for details"; \
		exit 1; \
	fi

.PHONY: clean

clean:
	rm -f *.psm
	for serv in $(SERVLETS); do \
		cd $${serv}; \
		make -f $(PLUMBER_PREFIX)/lib/plumber/servlet.mk clean $(PARAM); \
		cd ..; \
	done;
