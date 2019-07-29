#!/bin/bash

#
# https://github.com/peripheryapp/periphery
#

clear

printf "\n"
printf "\n# %s\n" "$now #"

echo "###########################################"
echo "############## periphery ##################"
echo "###########################################"

#
# Find unused code
# https://github.com/peripheryapp/periphery
#

periphery scan \
--project "~/Desktop/GitHub/RJPS_MVPCleanRx/GoodToGo.xcodeproj/" \
--schemes "GoodToGo.Debug.Dev" \
--targets "GoodToGo" \
--retain-public


#
# Tool to enforce Swift style and conventions
# https://github.com/realm/SwiftLint
#

echo "###########################################"
echo "############## swiftlint ##################"
echo "###########################################"

# swiftlint version
# swiftlint rules
# swiftlint generate-docs

#swiftlint lint > report.swiftlint.txt
swiftlint lint


