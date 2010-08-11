xml2rfc = "../xml2rfc/xml2rfc.tcl"
saxpath = "/opt/local/share/java/saxon8.jar"
saxon = java -classpath $(saxpath) net.sf.saxon.Transform -novw -l
stylesheet = ../rfc2629xslt/rfc2629.xslt

TITLE= nottingham-http-pipeline
VERSION= 01

TARGET_XML= draft-$(TITLE)-$(VERSION).xml
TARGET_HTML= $(TARGET_XML:.xml=.html)
TARGET_TXT= $(TARGET_XML:.xml=.txt)
NEXT_XML= draft-$(TITLE)-$(shell printf "%.2d" `echo ${VERSION}+1 | bc`).xml

TARGETS = $(TARGET_HTML) \
          $(TARGET_TXT)

all: $(TARGETS)

clean:
	rm -f $(TARGETS)

next: 
	cp $(TARGET_XML) $(NEXT_XML)

.PHONY: idnits
idnits: $(TARGET_TXT)
	idnits $<

%.html: %.xml
	$(saxon) $< $(stylesheet) > $@

%.txt: %.xml
	$(xml2rfc) $< $@
