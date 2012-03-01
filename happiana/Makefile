xml2rfc = "../xml2rfc/xml2rfc.tcl"
saxon = saxon
stylesheet = /usr/local/share/rfc2629xslt/rfc2629.xslt

TITLE= nottingham-appsawg-happiana
VERSION= 00
# Once the RFC number is assigned by IANA
# RFC= 0

ifndef ($RFC) 
	TARGET_XML= draft-$(TITLE)-$(VERSION).xml
	PREV_TXT= draft-$(TITLE)-$(shell printf "%.2d" `echo ${VERSION}-1 | bc`).txt
	NEXT_XML= draft-$(TITLE)-$(shell printf "%.2d" `echo ${VERSION}+1 | bc`).xml
else
	TARGET_XML= rfc$(RFC).xml
	PREV_TXT= draft-$(TITLE)-$(VERSION).txt
endif

TARGET_HTML= $(TARGET_XML:.xml=.html)
TARGET_TXT= $(TARGET_XML:.xml=.txt)
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
