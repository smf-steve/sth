SRC =  .
DST ?= /tmp

install: bin 

.PHONY: bin 
bin:
	-mkdir -p ${DST}/bin 2> /dev/null
	-cp bin/sth_* ${DST}/bin
	-cp README.md ${DST}/bin/sth.md


