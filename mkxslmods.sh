#!/bin/bash
# makes a directory and transforms mods files in
# directory in parameter and saves them in 
# new directory
#
## assume we're processing collection 'foo'
mkdir xsl-mods-$1
for X in mods-$1/*.xml;
 do nX=`basename $X`;
 xsltproc -o xsl-mods-$1/$nX oai-mods-add-thumbnail-url.xsl $X;
 done
