saxpath = "/opt/local/share/java/saxon8.jar"
saxon = java -classpath $(saxpath) net.sf.saxon.Transform -novw -l
stylesheet = "../rfc2629xslt/rfc2629.xslt"
xml2rfc = "../xml2rfc/xml2rfc.tcl"

TITLE = nottingham-$(shell basename ${CURDIR})
LATEST = $(shell ls draft-${TITLE}-*.xml | sort | tail -1)
VERSION = $(shell basename ${LATEST} .xml | awk -F- '{print $$NF}')

TARGET_XML = draft-$(TITLE)-$(VERSION).xml
PREV_TXT = draft-$(TITLE)-$(shell printf "%.2d" `echo ${VERSION}-1 | bc`).txt
NEXT_XML = draft-$(TITLE)-$(shell printf "%.2d" `echo ${VERSION}+1 | bc`).xml

TARGET_HTML = $(TARGET_XML:.xml=.html)
TARGET_TXT = $(TARGET_XML:.xml=.txt)
TARGETS = $(TARGET_HTML) \
          $(TARGET_TXT)

.PHONY: all
all: $(TARGETS)

.PHONY: clean
clean:
	rm -f $(TARGETS)

.PHONY: next
next: 
	cp $(TARGET_XML) $(NEXT_XML)

.PHONY: diff
diff: 
	rfcdiff $(PREV_TXT) $(TARGET_TXT)

.PHONY: idnits
idnits: $(TARGET_TXT)
	idnits $<

%.html: %.xml
	$(saxon) $< $(stylesheet) > $@

%.txt: %.xml
	$(xml2rfc) $< $@
