xml2rfc = "../xml2rfc/xml2rfc.tcl"
saxpath = "/opt/local/share/java/saxon8.jar"
saxon = java -classpath $(saxpath) net.sf.saxon.Transform -novw -l
stylesheet = ../rfc2629xslt/rfc2629.xslt

TITLE= nottingham-http-portal
VERSION= 02

TARGET_XML= draft-$(TITLE)-$(VERSION).xml
TARGET_HTML= $(TARGET_XML:.xml=.html)
TARGET_TXT= $(TARGET_XML:.xml=.txt)
PREV_TXT= draft-$(TITLE)-$(shell printf "%.2d" `echo ${VERSION}-1 | bc`).txt
NEXT_XML= draft-$(TITLE)-$(shell printf "%.2d" `echo ${VERSION}+1 | bc`).xml

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
