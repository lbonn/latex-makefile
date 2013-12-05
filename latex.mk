# disable built-in rules
.SUFFIXES:

# define latex files to build in TARGETS

# parameters
LATEX ?= latex
DVIPS ?= dvips
PS2PDF ?= ps2pdf
PS2EPS ?= ps2epsi
MAKEINDEX ?= makeindex
GLOSSARY ?= 0

# temporary files (for cleaning)
AUX_F = $(TARGETS:.tex=.aux)
LOG_F = $(TARGETS:.tex=.log)
TOC_F = $(TARGETS:.tex=.toc)
GLO_F = $(TARGETS:.tex=.glo)
IST_F = $(TARGETS:.tex=.ist)
GLG_F = $(TARGETS:.tex=.glg)
GLS_F = $(TARGETS:.tex=.gls)
OUT_F = $(TARGETS:.tex=.out)
DVI_F = $(TARGETS:.tex=.dvi)
PS_F = $(TARGETS:.tex=.ps)
PDF_F = $(TARGETS:.tex=.pdf)

# rules
.PHONY: clean

%.aux: %.tex
	$(LATEX) $<

%.toc: %.tex
	$(LATEX) $<

%.glo: %.tex
	$(LATEX) $<

%.gls: %.glo
	$(MAKEINDEX) $< -s $(<:.glo=.ist) -t $(<:.glo=.glg) -o $(<:.glo=.gls)

ifeq ($(GLOSSARY),1)
%.dvi: %.tex %.gls %.aux %.toc
	$(LATEX) $<
	- $(RM) $(<:.tex=.log) $(<:.tex=.glo) $(<:.tex=.ist) $(<:.tex=.glg)
else
%.dvi: %.tex %.aux %.toc
	$(LATEX) $<
	- $(RM) $(<:.tex=.log)
endif

%.ps: %.dvi
	$(DVIPS) $<

%.eps: %.ps
	$(PS2EPS) $< $@

%.pdf: %.ps
	$(PS2PDF) $<

clean:
	- $(RM) $(AUX_F) $(LOG_F) $(TOC_F) $(DVI_F) $(PS_F) $(GLO_F) $(GLG_F) $(IST_F) $(GLS_F) $(OUT_F) $(PDF_F)

