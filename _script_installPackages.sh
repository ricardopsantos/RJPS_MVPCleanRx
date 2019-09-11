#!/bin/bash

#
# ** Check Swift (xcodebuild) Compiler version **
#
# xcrun swift -version
# xcode-select --print-path
#
# ** Change Swift (xcodebuild) Compiler version **
#
# sudo xcode-select --switch "/Applications/Xcode.app/Contents/Developer"
# sudo xcode-select --switch "/Applications/Xcode_11-beta.app/Contents/Developer"
#

clear

echo '# Swift Version'
eval xcrun swift -version

echo '# Select Xcode'
eval xcode-select --print-path

# eval brew update

# eval brew install carthage

eval brew upgrade carthage

eval carthage update --platform iOS

