
id_base = ..
xml2rfc ?= xml2rfc
saxpath ?= /usr/local/share/saxon-b/saxon9.jar
kramdown-rfc2629 ?= kramdown-rfc2629
bootstrap ?= ../Tools/rfcbootstrap/rfcbootstrap.xslt
extra_css ?= ../Tools/style.css
idnits ?= idnits

shortname = $(shell basename ${CURDIR})
title = nottingham-${shortname}
latest = $(shell (ls draft-${title}-*.xml || echo "draft-${title}-00.xml") | sort | tail -1)
version = $(shell basename ${latest} .xml | awk -F- '{print $$NF}')

target = draft-$(title)-$(version)
prev = draft-$(title)-$(shell printf "%.2d" `echo ${version}-1 | bc`)
next = draft-$(title)-$(shell printf "%.2d" `echo ${version}+1 | bc`)

.PHONY: latest clean next diff idnits update

latest: $(target).html $(target).txt index.html index.txt

clean:
	rm -f $(target).html $(target).txt

next: 
	cp $(target).xml $(next).xml
	sed -i '' -e"s/$(target)/$(next)/" draft.md

diff: 
	rfcdiff $(prev).txt $(target).txt

idnits: $(target).txt
	$(idnits) $<

%.xml: draft.md
	$(kramdown-rfc2629) $< > $@
	
%.html: %.xml $(bootstrap) $(extra_css)
	sed -i '' -e"s/\"rfc2629.dtd/\"$(id_base)\/Tools\/rfcbootstrap\/rfc2629.dtd/" $<
	java -classpath $(saxpath) net.sf.saxon.Transform -l $< $(bootstrap) \
	bootstrapJsUrl='../Tools/node_modules/bootstrap/dist/js/bootstrap.min.js' \
	bootstrapCssUrl=$(extra_css) \
	jqueryJsUrl='../Tools/node_modules/jquery/dist/jquery.min.js' \
	pageUrl='https://mnot.github.io/I-D/${shortname}/' \
	siteName="mnot's Internet Drafts" \
	navbar='../Tools/navbar.html' \
	> $@
#	$(xml2rfc) --html $< $@

%.txt: %.xml
	$(xml2rfc) $< $@

index.html: $(target).html
	cp $< $@

index.txt: $(target).txt
	cp $< $@

update:
	cp $(id_base)/Tools/skel/Makefile .
