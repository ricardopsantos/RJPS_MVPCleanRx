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
    [y] ) carthage update --no-use-binaries --platform iOS ;;
   *) echo "Ignored...."
;;
esac

################################################################################

printf "\n"
printf "\n"

echo "${GREEN} ╔═══════════════════════╗"
echo "${GREEN} ║ Done! You're all set! ║"
echo "${GREEN} ╚═══════════════════════╝${NOCOLOR}"
