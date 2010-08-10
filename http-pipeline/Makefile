xml2rfc = "../xml2rfc/xml2rfc.tcl"
saxpath = "/opt/local/share/java/saxon8.jar"
saxon = java -classpath $(saxpath) net.sf.saxon.Transform -novw -l
stylesheet = ../rfc2629xslt/rfc2629.xslt

TITLE= nottingham-http-pipeline
VERSION= 00

TARGETS_XML= draft-$(TITLE)-$(VERSION).xml
TARGETS_HTML= $(TARGETS_XML:.xml=.html)
TARGETS_TXT= $(TARGETS_XML:.xml=.txt)

TARGETS = $(TARGETS_HTML) \
          $(TARGETS_TXT)

all: $(TARGETS)

clean:
	rm -f $(TARGETS)

.PHONY: idnits
idnits: $(TARGETS_TXT)
	idnits $<

%.html: %.xml
	$(saxon) $< $(stylesheet) > $@

%.txt: %.xml
	$(xml2rfc) $< $@
