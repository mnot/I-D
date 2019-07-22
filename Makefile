
# Create a new draft
# Usage: make [draft-short-name]

files = $(wildcard *)
scss_files = $(wildcard Tools/scss/*.scss)
reserved = Abandoned Published Tools Makefile draft_head.html index.html draft_foot.html README.md _includes _layouts _site
drafts = $(filter-out $(reserved), $(files))

%::
	cp -a Tools/skel $@
	mv $@/draft-nottingham--00.xml $@/draft-nottingham-$@-00.xml
	sed -i '' -e"s/SHORTNAME/$@/g" \
		$@/draft-nottingham-$@-00.xml
	sed -i '' -e"s/SHORTNAME/$@/g" \
		$@/draft.md

index.html: $(drafts) Tools/index.py
	cat draft_head.html > $@
	echo "$(foreach draft,$(drafts),\n<li><a href='$(draft)'>$(draft)</a> - $(shell Tools/index.py $(draft)/draft.md)</li>)" >> $@
	cat draft_foot.html >> $@

Tools/style.css: $(scss_files)
	scss Tools/scss/style.scss > $@

.PHONY: bootstrap
bootstrap:
	git submodule update --remote
