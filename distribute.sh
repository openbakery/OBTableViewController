#!/bin/sh

NAME="OBTableViewController"
VERSION=1.2.2

DISTRIBUTION_FILE=${NAME}-${VERSION}
DISTRIBUTION_PATH=build/${DISTRIBUTION_FILE}


IOS_ARCHIVE_PATH="./build/archive/ios.xcarchive"
IOS_SIMULATOR_ARCHIVE_PATH="./build/archive/ios_simulator.xcarchive"

echo "Clean"
rm -rf build
mkdir build

echo "Build"
./build.sh


EXIT_CODE=$?
if [ "${EXIT_CODE}" -ne "0" ]; then
    echo Build failed
    exit ${EXIT_CODE}
fi

echo "Create Distribution"
mkdir "${DISTRIBUTION_PATH}"

cp -R "build/${NAME}.xcframework" "${DISTRIBUTION_PATH}"
cp "Readme.md" "${DISTRIBUTION_PATH}"
cp "LICENSE" "${DISTRIBUTION_PATH}"

pushd build
zip --recurse-paths ${DISTRIBUTION_FILE}.zip ${DISTRIBUTION_FILE}
popd
