#!/bin/sh

NAME="OBTableViewController"

IOS_ARCHIVE_PATH="./build/archive/ios.xcarchive"
IOS_SIMULATOR_ARCHIVE_PATH="./build/archive/ios_simulator.xcarchive"

echo "Build"
xcodebuild archive -scheme ${NAME} -archivePath ${IOS_ARCHIVE_PATH} -sdk iphoneos SKIP_INSTALL=NO -destination 'generic/platform=iOS'
xcodebuild archive -scheme ${NAME} -archivePath ${IOS_SIMULATOR_ARCHIVE_PATH} -sdk iphonesimulator SKIP_INSTALL=NO -destination 'generic/platform=iOS Simulator'


echo "Create xcframework"
xcodebuild -create-xcframework \
  -framework ${IOS_ARCHIVE_PATH}/Products/Library/Frameworks/${NAME}.framework \
  -framework ${IOS_SIMULATOR_ARCHIVE_PATH}/Products/Library/Frameworks/${NAME}.framework \
  -output "./build/${NAME}.xcframework"


