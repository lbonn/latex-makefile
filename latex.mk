# disable built-in rules
.SUFFIXES:

# define pdf files to build in PDF_F

# parameters
LATEX ?= latex
DVIPS ?= dvips
PS2PDF ?= ps2pdf
MAKEINDEX ?= makeindex
GLOSSARY ?= 0

TEX_F = $(PDF_F:.pdf=.tex)

# temporary files (for cleaning)
AUX_F = $(PDF_F:.tex=.aux)
LOG_F = $(PDF_F:.tex=.log)
TOC_F = $(PDF_F:.tex=.toc)
GLO_F = $(PDF_F:.tex=.glo)
IST_F = $(PDF_F:.tex=.ist)
GLG_F = $(PDF_F:.tex=.glg)
GLS_F = $(PDF_F:.tex=.gls)
OUT_F = $(PDF_F:.tex=.out)
DVI_F = $(PDF_F:.tex=.dvi)
PS_F = $(PDF_F:.tex=.ps)

# rules
.PHONY: all clean

all: $(PDF_F)

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
	- $(RM) $(<:.tex=.log)
endif

%.ps: %.dvi
	$(DVIPS) $<

%.pdf: %.ps
	$(PS2PDF) $<

clean:
	- $(RM) $(AUX_F) $(LOG_F) $(TOC_F) $(DVI_F) $(PS_F) $(GLO_F) $(GLG_F) $(IST_F) $(GLS_F) $(OUT_F) $(PDF_F)

