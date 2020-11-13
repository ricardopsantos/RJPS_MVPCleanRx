
clear

echo 'Xcodegen...'
xcodegen -s ./XcodeGen/project.yml -p ./
echo 'done!'

open RJSLibUF.xcodeproj

echo ''

echo 'Xcodegen graphviz...'
cd XcodeGen
xcodegen dump --type graphviz --file ../AuxiliarDocs/Graph.viz
xcodegen dump --type json --file ../AuxiliarDocs/Graph.json
echo 'done!'


