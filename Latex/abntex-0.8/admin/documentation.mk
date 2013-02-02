#$Header: /home/cvsroot/abntex/Makefile,v 1.30 2003/10/17 14:21:09 gweber Exp $
export LATEXDOCDIR=${SOURCEDOC}/latex/abntex
export BIBTEXDOCDIR=${SOURCEDOC}/bibtex/abntex

export LATEXSDOCS=${wildcard ${LATEXDOCDIR}/abnt*.tex} ${wildcard ${LATEXDOCDIR}/tab*.tex}

export LATEXSCSS=${wildcard ${LATEXDOCDIR}/*.css}
export BIBTEXSDOCS=${wildcard ${BIBTEXDOCDIR}/*.tex}
export BIBTEXSCSS=${wildcard ${BIBTEXDOCDIR}/*.css}

export LATEXDOCS=${subst ${LATEXDOCDIR},${CDOCDIR},${LATEXSDOCS}}
export LATEXCSS=${subst ${LATEXDOCDIR},${CDOCDIR},${LATEXSCSS}}

export BIBTEXDOCS=${subst ${BIBTEXDOCDIR},${CDOCDIR},${BIBTEXSDOCS}}
export BIBTEXCSS=${subst ${BIBTEXDOCDIR},${CDOCDIR},${BIBTEXSCSS}}

export ALLSDOCS=${BIBTEXSDOCS} ${LATEXSDOCS}
export ALLDOCS=${BIBTEXDOCS} ${LATEXDOCS}
export ALLCSS=${BIBTEXCSS} ${LATEXCSS}

export DVIDOCS=${ALLDOCS:.tex=.dvi}
export PDFDOCS=${ALLDOCS:.tex=.pdf}
export PSGZDOCS=${ALLDOCS:.tex=.ps.gz}
export HTMLDOCS=${ALLDOCS:.tex=.html}

#variáveis de ambiente que precisam ser exportados para rodar a
#documentação corretamente
export TEXINPUTS=$(shell pwd)/texmf/tex/latex//:
export BIBINPUTS=$(shell pwd)/texmf/bibtex/bib//:
export BSTINPUTS=$(shell pwd)/texmf/bibtex/bst//:
export INDEXSTYLE=$(shell pwd)/texmf/tex/latex//:

#aqui nos alteramos a variável TEX da regra implícita %.dvi:%.tex
#para as particularidades de cada documento
${CDOCDIR}/abnt-bibtex-doc.dvi: TEX=${LBLBLL}
${CDOCDIR}/abnt-bibtex-doc.pdf: TEX=${LBLBLL}
${CDOCDIR}/abnt-bibtex-alf-doc.dvi: TEX=${LBLL}
${CDOCDIR}/abnt-bibtex-alf-doc.pdf: TEX=${LBLL}
${CDOCDIR}/abnt-classe-doc.dvi: TEX=${LLL}
${CDOCDIR}/abnt-classe-doc.pdf: TEX=${LLL}
${CDOCDIR}/tabela-simbolos-doc.dvi: TEX=${LTBLL}
${CDOCDIR}/tabela-simbolos-doc.pdf: TEX=${LTBLL}
${CDOCDIR}/inpi-ex.dvi: TEX=${LLL}

#expande o nome do arquivo
export FILE=	$(basename $(notdir $<))

#expande o comando de mudança de diretório
export CDDIR=  cd $(dir $<);

#arquivos dos pacotes
export ABNTEXDOC=${subst abntex,abntex-doc,${ABNTEX}}
export ABNTEXDOCTGZ=${ABNTEXDOC}.tgz
export ABNTEXDOCZIP=${ABNTEXDOC}.zip
export ABNTEXDOCRPM=${ABNTEXDOC}.noarch.rpm

export LATEX=latex

#roda latex e bibtex de modo a resolver todas as referências
export LBLBLL= cd ${CDOCDIR}; ${LATEX} ${FILE};\
	bibtex ${FILE}; ${LATEX} ${FILE}; \
	bibtex ${FILE}; ${LATEX} ${FILE}; latex ${FILE}

#documento com bibliografia simples
export LBLL= cd ${CDOCDIR}; ${LATEX} ${FILE};\
	bibtex ${FILE}; ${LATEX} ${FILE}; ${LATEX} ${FILE}

#documento com bibliografia e lista de tabelas
export LTBLL= cd ${CDOCDIR}; ${LATEX} ${FILE};\
	${GERATSS} ${FILE}; bibtex ${FILE};\
	${LATEX} ${FILE}; ${GERATSS} ${FILE}; ${LATEX} ${FILE}

#documento simples
export LLL= cd ${CDOCDIR}; ${LATEX} ${FILE}; ${LATEX} ${FILE}; ${LATEX} ${FILE}

${CDOCDIR}:
	mkdir ${CDOCDIR}

${BIBTEXDOCS} ${BIBTEXCSS}: ${CDOCDIR}
	cp ${OPF} ${BIBTEXDOCDIR}/$(notdir $@) $@

${LATEXDOCS} ${LATEXCSS}: ${CDOCDIR}
	ln ${OPSF} ${LATEXDOCDIR}/$(notdir $@) $@

#dependência entre dvi<->ps
%.ps: %.dvi
	cd ${CDOCDIR}; \
	dvips -t a4 -o ${FILE}.ps ${FILE}

#compressão do arquivo ps
%.ps.gz: %.ps
	cd ${CDOCDIR}; gzip --force $<

#dependência entre pdf<->tex
%.pdf: %.tex
	$(subst latex,pdflatex,${TEX})$

HTMLOPT= -split 0 -noinfo -noaddress -html_version 4.0 -no_navigation

%.html: %.dvi
	${CDDIR} latex2html ${HTMLOPT} ${FILE}; \
	ln ${OPSF} ${FILE}/index.html ${FILE}.html

#doc-clean remove arquivos intermediários desnecessários (exceto *.dvi)
#em compiled.docs
clean: ${CDOCDIR}
	cd ${CDOCDIR};\
	rm ${OPVF} *.log *.blg *.bbl *.aux *.toc *.idx *.los *.lot *.out *.ilg\
	*.sigla* *.symbols*

#com clean somente os arquivos fonte sobram
remove:
	rm ${OPRF} ${CDOCDIR}

remove-links:
	cd ${CDOCDIR};\
	rm ${OPVF} *.tex *.css


all:  doc-clean doc-dvi doc-ps doc-html doc-clean doc-pdf doc-clean doc-remove-links

#cria links dos fontes da documentação para a criação de
#documentação compilada no diretório CDOCDIR
links: ${ALLDOCS} ${ALLCSS}

dvi: ${DVIDOCS}

pdf: ${PDFDOCS}

ps:	 ${PSGZDOCS}

html: ${HTMLDOCS}

#O empacotamento para Linux

export DOCLIST = ${PACKDIR}/$(notdir ${CDOCDIR})


#pacote opcional com a documentação precompilada em dvi, pdf, ps e html
linux-doc-tgz: doc ${PACKDIR}
	cd ..; \
	ln ${OPSF} ${ABNTEXDIR} ${PACKDIR}; \
	rm ${OPVR} ${ABNTEXDOCTGZ};\
	tar ${OPTAR} -f ${ABNTEXDOCTGZ} ${DOCLIST};\
	rm ${PACKDIR}
