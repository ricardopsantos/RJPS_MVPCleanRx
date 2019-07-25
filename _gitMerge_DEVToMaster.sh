#!/bin/bash

clear

var_branch_Source="DEV"
var_branch_Desteny="master"

echo ""
echo "Automatic merge will start..."
echo "Folder: $var_folder_Source | Branch_A: $var_branch_Source | Branch_B: $var_branch_Desteny"
echo ""
echo "Press any key to continue..."
read -p "$*"

## Ignore all changes

#./__generic_ignoreChanges.sh $var_folder_Source $var_branch_Desteny

## Merge

./_gitGenericMerge.sh $var_branch_Source $var_branch_Desteny






