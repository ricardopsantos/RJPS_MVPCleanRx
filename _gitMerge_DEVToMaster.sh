#!/bin/bash

clear

var_branch_Source="DEV"
var_branch_Desteny="master"
var_version="1.0.2"

echo ""
echo "Automatic merge will start..."
echo "Folder: $var_folder_Source | Branch_A: $var_branch_Source | Branch_B: $var_branch_Desteny"
echo ""
echo "Press any key to continue..."
read -p "$*"

./_gitGenericMerge.sh $var_branch_Source $var_branch_Desteny $var_version






