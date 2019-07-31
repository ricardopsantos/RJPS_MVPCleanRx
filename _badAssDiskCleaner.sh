#!/bin/bash

clear

function willRun(){
   printf 'Will run $ '
   read -p "$*"
   printf '\n'
}

function showStorage() {
    eval df | awk '/\/dev\/disk*/ && ! /\/private\/var\/vm/ {
        s_byte = $2 * 512            # covert blocks to bytes
        a_byte = $4 * 512
        ts_byte+=s_byte              # add bytes for each device
        ta_byte+=a_byte              # to their total
    }
    END {
        ts_byte=ts_byte/1000000000   # convert bytes to GB
        ta_byte=ta_byte/1000000000
        ts_byte=ts_byte/2
        ta_byte=ta_byte/2
    print "# Disk Capacity :", ts_byte,"G\n# Available     :", ta_byte,"G\n"
    }'
}

now=$(date)
printf "\n# Automatic Xcode data cleanner will run! %s\n\n" "$now #"
showStorage

willRun "rm -rf ~/Library/Developer/Xcode/DerivedData"
eval rm -rf ~/Library/Developer/Xcode/DerivedData

willRun "rm -rf ~/Library/Developer/Xcode/Archives"
eval rm -rf ~/Library/Developer/Xcode/Archives

willRun "rm -rf ~/Library/Developer/Xcode/iOS\ Device\ Logs"
eval rm -rf ~/Library/Developer/Xcode/iOS\ Device\ Logs

willRun "rm -rf ~/Library/Developer/Xcode/watchOS\ DeviceSupport"
eval rm -rf ~/Library/Developer/Xcode/watchOS\ DeviceSupport

willRun "rm -rf ~/Library/Developer/Xcode/UserData/IB\ Support"
eval rm -rf ~/Library/Developer/Xcode/UserData/IB\ Support

willRun "rm -rf ~/Library/Developer/Xcode/Products"
eval rm -rf ~/Library/Developer/Xcode/Products

willRun "xcrun simctl erase all"
eval xcrun simctl erase all

willRun "rm -rf ~/.Trash/*"
eval

showStorage

printf "# DONE!\n\n"
printf "# More? (not executed)\n\n"
printf " sudo rm rm -rf ~/.Trash/*/\n"
printf " cd /Library/Developer/CoreSimulator/Profiles/Runtimes\n"
printf " sudo rm -rf iOS\ 8.4.simruntime/s\n"
printf " sudo rm -rf watchOS\ 2.2.simruntime/\n\n"


