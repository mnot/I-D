
This is the source for draft-nottingham-http-pipeline, an IETF Internet-Draft.

Requirements
============

Building requires:

 * xml2rfc - create an 'xml2rfc' directory (or symlink it); see <http://xml.resource.org/>, and
 * rfc2629xslt - create a 'rfc2629' directory (or symlink); see <http://greenbytes.de/tech/webdav/rfc2629xslt.zip>.

Make Targets
============

The current version that the build will operate upon is set by the VERSION variable in the makefile.

 * all - build the current version of the textual and HTML drafts.
 * clean - remove the current version of the textual and HTML drafts.
 * idnits - check the current version with the idnits tool.
 * next - create the source XML file for the next version; perform BEFORE 
   incrementing VERSION.
