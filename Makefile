.PHONY: all check clean

all: check

check:
	cd test; make

clean:
	cd test; make clean
