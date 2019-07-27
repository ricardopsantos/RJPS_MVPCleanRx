#!/bin/bash

#
# https://github.com/peripheryapp/periphery
#

# /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# eval brew tap peripheryapp/periphery
# eval brew cask install periphery
# brew cask reinstall periphery

periphery scan \
--project "/Users/ricardopsantos/Desktop/GitHub/RJPS_MVPCleanRx/GoodToGo.xcodeproj/" \
--schemes "GoodToGo.Debug.Dev" \
--targets "GoodToGo" \
--retain-public


#
# https://github.com/realm/SwiftLint
#

# brew install swiftlint

swiftlint

