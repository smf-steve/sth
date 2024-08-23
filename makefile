STH_HOME ?=  .
DST ?= /tmp

install: bin 

.PHONY: bin 
bin:
	-mkdir -p ${DST}/bin 2> /dev/null
	-cp ${STH_HOME}/bin/sth_* ${DST}/bin
	-cp ${STH_HOME}/README.md ${DST}/bin/sth.md


