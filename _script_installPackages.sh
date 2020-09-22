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
echo " [2] : Update"
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
echo " [1] : Xcode current - Version 11.1 (11A1027)"
echo " [2] : Xcode Version 11.0 (11A420a)"
echo " [3] : Xcode Version 10.3 (10G8)"
echo " [4] : Xcode Version 9.4.1 (9F2000)"
echo " [5] : Skip"
printf "\n"
echo -n "Option? "
read option
case $option in
    [1] ) sudo xcode-select --switch "/Applications/Xcode.app/Contents/Developer" ;;
    [2] ) sudo xcode-select --switch "/Applications/Xcode_11.app/Contents/Developer" ;;
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

echo "### Perform 'carthage update --platform iOS'?"
echo " [y] :Yes"
echo " [n] :No/Skip"
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
