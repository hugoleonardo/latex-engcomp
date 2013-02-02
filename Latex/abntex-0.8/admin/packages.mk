#$Header: /home/cvsroot/abntex/Makefile,v 1.30 2003/10/17 14:21:09 gweber Exp $

export USRLOCAL=/usr/local/bin

#Do "man lyx":
#The system directory is determined by  searching  for  the
#       file  "chkconfig.ltx".
export LYXDIR=${dir ${shell  find /usr/share/lyx -name chkconfig.ltx}}

#diretório corrente onde se expandiu o cvs do abntex
export ABNTEXDIR=$(notdir $(shell pwd))

#diretório onde se encontra a documentação original
export SOURCEDOC=$(shell pwd)/texmf/doc

#diretório para onde vai a documentação compilada
export CDOCDIR=$(shell pwd)/compiled.docs

#diretório onde estão as contribuições
export CONTRIBDIR=$(shell pwd)/contrib

#script para gerar tabela de símbolos
export GERATSS=$(shell pwd)/bin/geratss

#email da pessoa que envia os arquivos pro codigolivre
#edite se precisar
export SUBMITTER=$(shell logname)@$(shell hostname)

#opções para comandos comuns:
export OPS = --symbolic
export OPSF= --symbolic --force
export OPVR= --verbose --recursive
export OPRF= --recursive --force
export OPVF= --verbose --force
#opções comuns para tar
export OPTAR= --owner=0 --group=0 -zchv

doc-%:
	${MAKE} -C admin -f documentation.mk $*

#expande o nome do arquivo
export FILE=	$(basename $(notdir $<))

#expande o comando de mudança de diretório
export CDDIR=  cd $(dir $<);

#arquivos dos pacotes
export ABNTEXDOC=${subst abntex,abntex-doc,${ABNTEX}}
export ABNTEXLYX=${subst abntex,abntex-lyx,${ABNTEX}}
export ABNTEXTGZ=${ABNTEX}.tgz
export ABNTEXDOCTGZ=${ABNTEXDOC}.tgz
export ABNTEXZIP=${ABNTEX}.zip
export ABNTEXDOCZIP=${ABNTEXDOC}.zip
export ABNTEXSRCRPM=${ABNTEX}.src.rpm
export ABNTEXRPM=${ABNTEX}.noarch.rpm
export ABNTEXDOCRPM=${ABNTEXDOC}.noarch.rpm
export ABNTEXLYXRPM=${ABNTEXLYX}.noarch.rpm

#diretórios padrão do rpm (Conectiva)
export RPMS=/usr/src/rpm/RPMS/noarch
export SRPMS=/usr/src/rpm/SRPMS
export SOURCES=/usr/src/rpm/SOURCES
export BUILD=/usr/src/rpm/BUILD

export TEMPDIR=/tmp

#diretório para geração de pacotes
export PACKDIR=abntex-${VERSION}

doc: doc-clean doc-dvi doc-ps doc-html doc-clean doc-pdf doc-clean doc-remove-links

#O empacotamento para Linux

export PACKLIST= ${PACKDIR}/Makefile \
	  ${PACKDIR}/abntex_version ${PACKDIR}/abntex_release \
	  ${PACKDIR}/*.lst \
	  ${PACKDIR}/LEIAME ${PACKDIR}/LEIAME.make ${PACKDIR}/LEIAME.linux \
	  ${PACKDIR}/LEIAME.administracao \
	  ${PACKDIR}/texmf ${PACKDIR}/bin ${PACKDIR}/lyx

export DOCLIST = ${PACKDIR}/$(notdir ${CDOCDIR})

#principal pacote que contém os programas fontes do abnTeX
linux-tgz: ${PACKDIR}
	cd ..; \
	tar ${OPTAR}  --exclude-from ${ABNTEXDIR}/exc.lst -f ${ABNTEXTGZ} ${PACKLIST};\
	rm ${PACKDIR}

#pacote opcional com a documentação precompilada em dvi, pdf, ps e html
linux-doc-tgz: doc
	cd ..; \
	ln ${OPSF} ${ABNTEXDIR} ${PACKDIR}; \
	rm ${OPVR} ${ABNTEXDOCTGZ};\
	tar ${OPTAR} -f ${ABNTEXDOCTGZ} ${DOCLIST};\
	rm ${PACKDIR}

#verifica se todos os pacotes necessários existem no seu sistema
check-rpm-install:
	rpm -q cvs
	rpm -q rpm-build
	rpm -q latex2html perl perl-modules
	rpm -q lyx

#para montar pacotes tipo rpm será melhor você ser root.
conectiva-rpm:
	if test "$(shell whoami)" == "root" ; then \
	cp ../${ABNTEXTGZ} ${SOURCES};\
	sed "s/ABNTEXVERSION/${VERSION}/;s/ABNTEXRELEASE/${RELEASE}/" admin/abntex.spec > abntex.spec;\
	rpmbuild -ba --target=noarch --clean abntex.spec;\
	else\
	echo "you should be root to do this";\
	fi

windows-zip:
	cd ../; \
	rm ${OPVF} ${ABNTEXZIP};\
	ln ${OPSF} ${ABNTEXDIR} ${PACKDIR}; \
	zip -r ${ABNTEXZIP} ${PACKDIR} -x@${ABNTEXDIR}/zipexcl.lst;\
	rm ${PACKDIR}

windows-doc-zip: doc
	cd ../; \
	rm ${OPVF} ${ABNTEXDOCZIP};\
	ln ${OPSF} ${ABNTEXDIR} ${PACKDIR}; \
	zip -r ${ABNTEXDOCZIP} ${PACKDIR}/compiled.docs;\
	rm ${PACKDIR}

new-release: clean doc linux-tgz linux-doc-tgz windows-zip windows-doc-zip conectiva-rpm

upload:
	echo "open upload.codigolivre.org.br" > upload.ftp;\
	echo "user anonymous ${SUBMITTER}" >> upload.ftp;\
	echo "cd incoming" >> upload.ftp;\
	echo "passive" >> upload.ftp;\
	echo "put ../${ABNTEXTGZ} ${ABNTEXTGZ}" >> upload.ftp;\
	echo "put ../${ABNTEXDOCTGZ} ${ABNTEXDOCTGZ}" >> upload.ftp;\
	echo "put ../${ABNTEXZIP} ${ABNTEXZIP}" >> upload.ftp;\
	echo "put ../${ABNTEXDOCZIP} ${ABNTEXDOCZIP}" >> upload.ftp;\
	echo "put ${SRPMS}/${ABNTEXSRCRPM} ${ABNTEXSRCRPM}" >> upload.ftp;\
	echo "put ${RPMS}/${ABNTEXRPM} ${ABNTEXRPM}" >> upload.ftp;\
	echo "put ${RPMS}/${ABNTEXDOCRPM} ${ABNTEXDOCRPM}" >> upload.ftp;\
	echo "put ${RPMS}/${ABNTEXLYXRPM} ${ABNTEXLYXRPM}" >> upload.ftp;\
	echo "quit" >> upload.ftp
	ftp -v -n < upload.ftp
	rm upload.ftp


all: doc


test:
	echo "diretório corrente:" ${ABNTEXDIR}
	echo "caminho para o tetex:" ${TEXDIR}
	echo "caminho para o LyX:" ${LYXDIR}
	echo "${LATEXDOCS}"

