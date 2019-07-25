#!/bin/bash

clear

function willRun(){
    printf '# '
    read -p "$*"
    printf '\n'
}

echo -n "# Create GitTag (y/n)? "
read answer

if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo "Sample tag name: ProductName-VersionX.X.X-BuildX-01Jan2030"
	echo -n "# Tag name? "
	read tagName
    tag="git tag -a "$tagName" -m '"$tagName"'"
    willRun ""$tag""
#echo `($tag)`
eval $tag
    willRun "git push --tags"
#echo `(git push --tags)`
eval git push --tags
else
    echo 'Git tag ignored'
fi
