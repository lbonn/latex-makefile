.PHONY: all check clean

all: check

check:
	cd test; make -f make-simple && make -f make-glossary

clean:
	cd test; make -f make-simple clean && make -f make-glossary clean
