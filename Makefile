
default_target: spec

COQFLAGS= -Q ../bbv/theories bbv  -R ./src riscv  

DEPFLAGS:=$(COQFLAGS)

COQC=$(COQBIN)coqc
COQTOP=$(COQBIN)coqtop
COQDEP=$(COQBIN)coqdep $(DEPFLAGS)
COQDOC=$(COQBIN)coqdoc

%.vo: %.v
	$(COQC) $(COQFLAGS) $*.v 

# Note: Also depends on ../bbv, but bbv's version is checked by bedrock2's CI

riscv-semantics_version_check:
	./check_dep.sh riscv-semantics

hs-to-coq_version_check:
	./check_dep.sh hs-to-coq

util: $(patsubst %.v,%.vo,$(wildcard src/util/*.v))

spec: util $(patsubst %.v,%.vo,$(wildcard src/*.v))

encode: spec $(patsubst %.v,%.vo,$(wildcard src/encode/*.v))

# beware: the "encode(decode inst) = inst" proof takes about 25min (June 1st, 2018)
proofs: encode $(patsubst %.v,%.vo,$(wildcard src/proofs/*.v))

all: spec encode proofs

.depend depend:
	$(COQDEP) >.depend `find src -name "*.v"`


# Old Python-based conversion:

# beware: will overwrite src/Execute.v
convert_execute: riscv-semantics_version_check
	cd convert && python execute.py

# beware: will overwrite src/Decode.v
convert_decode: riscv-semantics_version_check
	cd convert && python decode.py


# New hs-to-coq-based conversion:

convert: riscv-semantics_version_check hs-to-coq_version_check
	cd convert-hs-to-coq && ./convert.sh


clean:
	find . -type f \( -name '*.glob' -o -name '*.vo' -o -name '*.aux' \) -delete
	rm .depend

include .depend

