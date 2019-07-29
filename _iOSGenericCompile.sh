#!/bin/bash

#
# ./iOSGenericCompile.sh "GoodToGo.xcodeproj" "MyAppName.AppStore"   "Release"  "[V2.0.2]" "~/Desktop/" "exportPlist.enterprise.plist"
# ./iOSGenericCompile.sh "GoodToGo.xcodeproj" "MyAppName.Enterprise" "Debug.Qa" "[V2.0.2]" "~/Desktop/" "exportPlist.appStore"

printf "\n"
printf "\n# %s\n" "$now #"
printf "# Compiler : "
echo `(xcrun swift -version)`
printf "# Xcode    : "
echo `(xcode-select --print-path)`
printf "\n"

ARGUMENT_A="$1"
ARGUMENT_B="$2"
ARGUMENT_C="$3"
ARGUMENT_D="$4"
ARGUMENT_E="$5"
ARGUMENT_F="$6"

var_xcodeproj=$ARGUMENT_A     #"GoodToGo.xcodeproj"
var_target=$ARGUMENT_B        #"GoodToGo.Debug.Dev"
var_configuration=$ARGUMENT_C #"Release"
var_appVersion=$ARGUMENT_D    #"[V2.0.1]"
var_output=$ARGUMENT_E        #"~/Desktop/"
var_plist=$ARGUMENT_F         #"exportPlist.enterprise.plist"

var_exportFileName="$var_target"_["$var_configuration"]_"$var_appVersion"
var_archivePath=""$var_output""$var_exportFileName""

echo "# Project        :" $var_xcodeproj
echo "# Target         :" $var_target
echo "# Config         :" $var_configuration
echo "# Version        :" $var_appVersion
echo "# OutputFolder   :" $var_output
echo "# ExportFileName :" $var_exportFileName
echo "# ExportArchive  :" $var_archivePath
echo "# plist          :" $var_plist

echo ""

doArquive() {
    to_run="xcodebuild PRODUCT_NAME="$var_target" -verbose archive -project "$var_xcodeproj" -configuration "$var_configuration" -scheme "$var_target" -archivePath "$var_archivePath".xcarchive -UseModernBuildSystem=NO"
    echo "#"
    echo "# Will run: "$to_run
    echo "#"
    eval $to_run

    var_zip="ditto -c -k --sequesterRsrc --keepParent "$var_archivePath".xcarchive "$var_archivePath".xcarchive.zip"
    echo "#"
    echo "# Will run: "$var_zip
    echo "#"
    eval $var_zip

}

doGenerateIPA() {
    to_run="xcodebuild -exportArchive -allowProvisioningUpdates -verbose -exportOptionsPlist "$var_plist" -archivePath "$var_archivePath".xcarchive -exportPath "$var_archivePath""
    echo "#"
    echo "# Will run: "$to_run
    echo "#"
    eval $to_run

    var_zip="ditto -c -k --sequesterRsrc --keepParent "$var_archivePath" "$var_archivePath".ipa.zip"
    echo "#"
    echo "# Will run: "$var_zip
    echo "#"

    eval $var_zip
}

doArquive

doGenerateIPA

#eval "rm "$var_output"/"$var_exportFileName".ipa.zip"
#eval "rm "$var_output"/"$var_exportFileName".xcarchive.zip"

rm -rf ~/Library/Developer/Xcode/DerivedData
rm -rf ~/Library/Developer/Xcode/Archives
rm -rf ~/Library/Developer/Xcode/iOS\ Device\ Logs
rm -rf ~/Library/Developer/Xcode/watchOS\ DeviceSupport
rm -rf ~/Library/Developer/Xcode/UserData/IB\ Support
rm -rf ~/Library/Developer/Xcode/Products
