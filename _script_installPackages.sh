#!/bin/bash


# echo -n "Do you agree with this? [yes or no]: "
# read yno
# case $yno in
#    [yY] | [yY][Ee][Ss] )
#       echo "Agreed"
#     ;;
#     [nN] | [n|N][O|o] )
#         echo "Not agreed, you can't proceed the installation";
#       exit 1
#      ;;
#   *) echo "Invalid input"
#;;
#esac

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

echo -n "### Brew"
printf "\n"
echo -n " - Install [1]: "
printf "\n"
echo -n " - Update [2]: "
printf "\n"
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
printf "\n"

echo -n "### Carthage"
printf "\n"
echo -n " - Install [1]: "
printf "\n"
echo -n " - Update [2]: "
printf "\n"
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

echo -n "### Change Compiler?"
printf "\n"
echo -n "[1] - Xcode (current) Version"
printf "\n"
echo -n " - Version 11.0 beta 6 [2]: "
printf "\n"
echo -n "Option? "
read option
case $option in
    [1] ) sudo xcode-select --switch "/Applications/Xcode.app/Contents/Developer" ;;
    [2] ) sudo xcode-select --switch "/Applications/Xcode_11-beta7.app/Contents/Developer" ;;
   *) echo "Ignored...."
;;
esac

################################################################################

displayCompilerInfo

################################################################################

printf "\n"
printf "\n"

echo -n "Perform 'carthage update --platform iOS'? [y]: "
printf "\n"
echo -n "Option: "
read option
case $option in
    [y] ) carthage update --platform iOS ;;
   *) echo "Ignored...."
;;
esac

################################################################################

printf "\n"
printf "\n"

echo "${GREEN} ╔═══════════════════════╗"
echo "${GREEN} ║ Done! You're all set! ║"
echo "${GREEN} ╚═══════════════════════╝${NOCOLOR}"
