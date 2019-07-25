#!/bin/bash

clear

function willRun(){
   printf '# '
   read -p "$*"
   printf '\n'
}

now=$(date)
printf "\n# Automatic merge started at %s\n\n" "$now #"
      
FIRST_ARGUMENT="$1"
SECOND_ARGUMENT="$2"
THIRD_ARGUMENT="$3"

var_version="2.0.2"
var_folder=""
var_branch_A=""
var_branch_A_1=""

if [ -z "$FIRST_ARGUMENT" ]
then
	var_folder="INVALID_FOLDER"
else
    var_folder=$FIRST_ARGUMENT
fi

if [ -z "$SECOND_ARGUMENT" ]
then
	var_branch_A="INVALID_BRANCH_A"
else
    var_branch_A=$SECOND_ARGUMENT
fi

if [ -z "$THIRD_ARGUMENT" ]
then
	var_branch_A_1="INVALID_BRANCH_B"
else
    var_branch_A_1=$THIRD_ARGUMENT
fi

printf "# Folder   : %s\n" $var_folder
printf "# Version  : %s\n" $var_version
printf "# Branch_1 : %s\n" $var_branch_A
printf "# Branch_2 : %s\n" $var_branch_A_1
printf '\n'
echo "###################################################"
echo "# Merge from ["$var_branch_A"] with ["$var_branch_A_1"]  #"
echo "###################################################"
printf '\n'
echo "# Merge will start in branch ["$var_branch_A"] currently at folder ["$var_folder"]"
printf '\n'

willRun "$ git checkout "$var_branch_A
echo `(cd $var_folder && git checkout $var_branch_A)`

willRun "git status"
echo `(cd $var_folder && git status)`

################################################################################
# Ignore changes?
################################################################################

echo -n "# Ignore all changes in branch [$var_branch_A] at folder [$var_folder] (y/n)? (default = NO)"
read answer1

if [ "$answer1" != "${answer1#[Yy]}" ] ;then
	./__ignoreChanges__GENERIC.sh $var_folder $var_branch_A
else
    echo 'Changes will be commited'
fi

################################################################################
# Get all branchs
################################################################################

echo "Getting all branchs..."
willRun "git fetch --all"
echo `(cd $var_folder && git fetch --all)`

################################################################################
# Create GitTag?
################################################################################

echo -n "# Create GitTag (y/n)? (default = NO)"
read answer2

if [ "$answer2" != "${answer2#[Yy]}" ] ;then
    tagDate_1=$(date '+%Y%m%d%H%M');
    tagDate_2=$(date '+%Y/%m/%d_%H:%M');
    tagName="$var_branch_A"_into_"$var_branch_A_1"_"$tagDate_1"
    tagCommitMessage="merge_$var_branch_A"_into_"$var_branch_A_1"_"$tagDate_2"
    tag="git tag -a merge_"$tagName" -m '"$tagCommitMessage"'"
    willRun ""$tag""
    echo `(cd $var_folder &&  $tag)`
    willRun "git push --tags"
    echo `(cd $var_folder && git push --tags)`
else
    echo 'Git tag ignored'
fi

################################################################################

willRun "git add."
echo `(cd $var_folder && git add .)`

#############################
# Commit message 1
#############################

commitMessage="merge - "$var_branch_A" to "$var_branch_A_1" - Part 1 - Version_"$var_version
echo -n "# Commit message: "
read answer3

if [ "$answer3" != "${answer2#[Yy]}" ] ;then
    commitMessage=$answer3
else
	echo 'Using default commit message - P1'
fi

################################################################################
#
# MERGE EVERYTHING FROM Branch_1 AND Branch_2 IN Branch_1
#
# 1 - Commit and Push to Branch_1
# 2 - Change (checkout) to Branch_2
# 3 - Get last version (Pull) from Branch_2
# 4 - Change (checkout) to Branch_1
# 5 - Merge Branch_1 & Branch_2 (in Branch_1)
# 7 - Commit and Pull to Branch_1
#
################################################################################

willRun "git commit -m '$commitMessage'"
echo `(cd $var_folder && git commit -m "$commitMessage")`

willRun "git push"
echo `(cd $var_folder && git push)`

willRun "$ git checkout "$var_branch_A_1
echo `(cd $var_folder && git checkout $var_branch_A_1)`

willRun "$ git pull"
echo `(cd $var_folder && git pull)`

willRun "$ git checkout "$var_branch_A
echo `(cd $var_folder && git checkout $var_branch_A)`

willRun "$ git merge "$var_branch_A_1
echo `(cd $var_folder && git merge $var_branch_A_1)`

willRun "git add."
echo `(cd $var_folder && git add .)`

#############################
# Commit message 2
#############################

commitMessage="merge - "$var_branch_A" to "$var_branch_A_1" - Part 2 - Version_"$var_version
echo -n "# Commit message: "
read answer3

if [ "$answer3" != "${answer2#[Yy]}" ] ;then
    commitMessage=$answer3
else
	echo 'Using default commit message - P2'
fi

commitMessage="merge - "$var_branch_A" to "$var_branch_A_1" - Part 2 - Version_"$var_version
willRun "git commit -m '$commitMessage'"
echo `(cd $var_folder && git commit -m "$commitMessage")`

willRun "$ git push"
echo `(cd $var_folder && git push)`

################################################################################
#
# MERGE EVERYTHING FROM Branch_1 AND Branch_2 IN Branch_1
#
# 8  - Change (checkout) to Branch_2
# 9  - Merge Branch_1 & Branch_2 (in Branch_2)
# 10 - Commit and Push to Branch_2
# 11 - Change (checkout) to Branch_1
# 12 - Check if everything is OK in Branch_1

willRun "$ git checkout "$var_branch_A_1
echo `(cd $var_folder && git checkout $var_branch_A_1)`

willRun "$ git merge "$var_branch_A
echo `(cd $var_folder && git merge $var_branch_A)`

#############################
# Commit message 3
#############################

commitMessage="merge - "$var_branch_A" to "$var_branch_A_1" - Part 3 - Version_"$var_version
echo -n "# Commit message: "
read answer3

if [ "$answer3" != "${answer3#[Yy]}" ] ;then
    commitMessage=$answer3
else
	echo 'Using default commit message - P3'
fi

willRun "git commit -m '$commitMessage'"
echo `(cd $var_folder && git commit -m "$commitMessage")`

willRun "$ git push"
echo `(cd $var_folder && git push)`

willRun "$ git checkout "$var_branch_A
echo `(cd $var_folder && git checkout $var_branch_A)`

willRun "git status"
echo `(cd $var_folder && git status)`


