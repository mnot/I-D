
# Create a new draft
# Usage: make [draft-short-name]

%::
	cp -a Tools/skel $@
	mv $@/draft-nottingham--00.xml $@/draft-nottingham-$@-00.xml
	sed -i '' -e"s/draft-nottingham--00/draft-nottingham-$@-00/" \
		$@/draft-nottingham-$@-00.xml
