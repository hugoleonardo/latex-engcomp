export CONTRIBVERSION= $(shell cat contrib_version)
export CONTRIB=abntex-contrib-${CONTRIBVERSION}
export PACKDIR=${TEMPDIR}/${CONTRIB}
export CONTRIBTGZ=${SOURCES}/${CONTRIB}.tgz
export CONTRIBZIP=${SOURCES}/${CONTRIB}.zip

clean:
	${MAKE} -C mestrado/dcrn clean

${PACKDIR}:
	ln ${OPSF} $(shell pwd) ${PACKDIR}

${CONTRIBTGZ}:  clean ${PACKDIR}
	tar ${OPTAR} --directory=${TEMPDIR} --exclude-from ${PACKDIR}/exc.lst -f $@ ${CONTRIB};


${CONTRIBZIP}:  clean ${PACKDIR}
	cd ${TEMPDIR};\
	zip -r $@ ${CONTRIB} -x@${CONTRIB}/zipexcl.lst

tgz: ${CONTRIBTGZ}

zip: ${CONTRIBZIP}

packages: tgz zip

upload: packages
	echo "open upload.codigolivre.org.br" > upload.ftp;\
	echo "user anonymous ${SUBMITTER}" >> upload.ftp;\
	echo "cd incoming" >> upload.ftp;\
	echo "passive" >> upload.ftp;\
	echo "put ${SOURCES}/${CONTRIB}.tgz ${CONTRIB}.tgz" >> upload.ftp;\
	echo "put ${SOURCES}/${CONTRIB}.zip ${CONTRIB}.zip" >> upload.ftp;\
	echo "quit" >> upload.ftp
	ftp -v -n < upload.ftp
	rm upload.ftp