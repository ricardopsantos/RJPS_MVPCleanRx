#!/bin/bash

clear

displayCompilerInfo() {
	printf "\n"
	printf "\n"
	echo -n "### Current Compiler"
	printf "\n"
	eval xcrun swift -version
	eval xcode-select --print-path
}

carthageBuild() {
    carthage build --no-use-binaries --platform iOS
}

#
# https://github.com/Carthage/Carthage/issues/3019
#

carthageBuildXcode12() {
    set -euo pipefail

    xcconfig=$(mktemp /tmp/static.xcconfig.XXXXXX)
    trap 'rm -f "$xcconfig"' INT TERM HUP EXIT

    # For Xcode 12 make sure EXCLUDED_ARCHS is set to arm architectures otherwise
    # the build will fail on lipo due to duplicate architectures.
    # Go to "Build Settings" -> "Architectures" -> "Excluded Architectures" and add "arm64"

    CURRENT_XCODE_VERSION=$(xcodebuild -version | grep "Build version" | cut -d' ' -f3)
    echo "EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_simulator__NATIVE_ARCH_64_BIT_x86_64__XCODE_1200__BUILD_$CURRENT_XCODE_VERSION = arm64 arm64e armv7 armv7s armv6 armv8" >> $xcconfig

    echo 'EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_simulator__NATIVE_ARCH_64_BIT_x86_64__XCODE_1200 = $(EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_simulator__NATIVE_ARCH_64_BIT_x86_64__XCODE_1200__BUILD_$(XCODE_PRODUCT_BUILD_VERSION))' >> $xcconfig
    echo 'EXCLUDED_ARCHS = $(inherited) $(EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_$(EFFECTIVE_PLATFORM_SUFFIX)__NATIVE_ARCH_64_BIT_$(NATIVE_ARCH_64_BIT)__XCODE_$(XCODE_VERSION_MAJOR))' >> $xcconfig

    export XCODE_XCCONFIG_FILE="$xcconfig"

    echo $xcconfig

    carthage build "$@" --no-use-binaries --platform iOS
}

################################################################################

echo "### Brew"
echo " [1] : Install"
echo " [2] : Update"
echo " [3] : Skip"
echo -n "Option? "
read option
case $option in
    [1] ) /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" ;;
    [2] ) eval brew update ;;
   *) echo "Brew options ignored...."
;;
esac

################################################################################

printf "\n"

echo "### Carthage"
echo " [1] : Install"
echo " [2] : Upgrade"
echo " [3] : Skip"
echo -n "Option? "
read option
case $option in
    [1] ) brew install carthage ;;
    [2] ) brew upgrade carthage ;;
   *) echo "Carthage options ignored...."
;;
esac

################################################################################

displayCompilerInfo

################################################################################

printf "\n"
printf "\n"

echo "### Change Compiler?"
echo " [1] : Xcode current"
echo " [2] : Xcode Version 11.4"
echo " [3] : Xcode Version 10.3"
echo " [4] : Xcode Version 9.4.1"
echo " [5] : Skip"
printf "\n"
echo -n "Option? "
read option
case $option in
    [1] ) sudo xcode-select --switch "/Applications/Xcode.app/Contents/Developer" ;;
    [2] ) sudo xcode-select --switch "/Applications/Xcode_11.4.app/Contents/Developer" ;;
    [3] ) sudo xcode-select --switch "/Applications/Xcode_10.3.app/Contents/Developer" ;;
    [4] ) sudo xcode-select --switch "/Applications/Xcode_9.4.1.app/Contents/Developer" ;;
   *) echo "Ignored...."
;;
esac

################################################################################

displayCompilerInfo

################################################################################

printf "\n"
printf "\n"

# carthage update --platform iOS --no-use-binaries
# carthage build --platform iOS --cache-builds --no-use-binaries --verbose

echo "### Perform 'carthage update --platform iOS'?"
echo " [y] :Yes"
echo " [n] :No/Skip"
printf "\n"
echo -n "Option: "
read option
case $option in
    [y] ) carthageBuildXcode12 ;;
   *) echo "Ignored...."
;;
esac

################################################################################

printf "\n"
printf "\n"

echo " ╔═══════════════════════╗"
echo " ║ Done! You're all set! ║"
echo " ╚═══════════════════════╝"
