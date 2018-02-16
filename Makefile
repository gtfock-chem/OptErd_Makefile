all: libs

libs:
	make -C external
	make -C libcint

clean:
	make -C libcint clean

cleanall: clean
	make -C external clean

install:
ifneq "${prefix}" ""
	mkdir -p ${prefix}
	rm -rf ${prefix}/lib ${prefix}/include
	cp -rf lib/ include/ ${prefix}
endif
