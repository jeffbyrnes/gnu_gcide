PROJECT ::= gcide
VERSION ::= $(shell head -n 1 INFO | sed -r -e 's/^.*, version[[:space:]]+//')

CORPUS   ::= $(wildcard CIDE.[A-Z])
AUXFILES ::= \
 COPYING\
 README\
 INFO\
 pronunc.png\
 symbols.png\
 pronunc.txt\
 tagset.txt\
 webfont.txt\
 abbrevn.lst\
 authors.lst\
 titlepage.png

DISTFILES ::= $(CORPUS) $(AUXFILES)

DISTBASE ::= $(PROJECT)-$(VERSION)
DIST_ARCHIVES ::= $(DISTBASE).tar.gz $(DISTBASE).tar.xz $(DISTBASE).zip

all:	$(DIST_ARCHIVES)
	@echo "Files ready for distribution:"
	@ls -oh $(DIST_ARCHIVES) | tr -s ' ' | cut -d ' ' -f 4,8 | sort -k 2 > list
	@md5sum $(DIST_ARCHIVES) | sort -k 2 | join -j 2 list -
	@rm -rf list $(DISTBASE)

clean:
	rm -f *~ *.bak

distclean: clean
	rm -rf $(DIST_ARCHIVES) .$(DISTBASE).ts $(DISTBASE)

.$(DISTBASE).ts: $(DISTFILES)
	rm -rf $(DISTBASE)
	mkdir $(DISTBASE)
	cp $(DISTFILES) $(DISTBASE)
	touch .$(DISTBASE).ts

$(DISTBASE).tar.gz: .$(DISTBASE).ts
	tar -Hustar -I 'gzip --best' -cf $(DISTBASE).tar.gz $(DISTBASE)

$(DISTBASE).tar.xz: .$(DISTBASE).ts
	tar -Hustar -J -cf $(DISTBASE).tar.xz $(DISTBASE)

$(DISTBASE).zip: .$(DISTBASE).ts
	zip -9 -q -r $(DISTBASE).zip $(DISTBASE)

GNUPLOAD = gnupload
UPLOAD_TO=ftp
GNUPLOAD_OPT=\
 --to $(UPLOAD_TO).gnu.org:$(PROJECT)\
 --to download.gnu.org.ua:$(UPLOAD_TO)/$(PROJECT)\
 --symlink-regex

release: $(DIST_ARCHIVES)
	@echo "Releasing $(DIST_ARCHIVES) to $(UPLOAD_TO)"
	$(GNUPLOAD) $(GNUPLOAD_OPT) $(DIST_ARCHIVES)

VRX ::= [[:digit:]]+(\.[[:digit:]]+)+

version_update:
	sed -i -r -e '1s/(, version[[:space:]]+)$(VRX)$$/\1$(VERSION)/' INFO
	sed -i -r -e '1,/^\*/s/(Version[[:space:]]+)$(VRX)[[:space:]]\([^)]+\)/\1$(VERSION) ('$$(date +%Y-%m-%d)')/' README

CIDE.%: FORCE
	~/src/dico/modules/gcide/tests/degcide $@ 2>&1 >/dev/null | \
            ~/src/dico/modules/gcide/tests/gcideloc >&2;
FORCE:

checkwf:
	-for file in $(CORPUS); \
	do \
           ~/src/dico/modules/gcide/tests/degcide $$file 2>&1 >/dev/null | \
            ~/src/dico/modules/gcide/tests/gcideloc >&2; \
	done

