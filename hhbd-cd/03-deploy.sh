#!/bin/bash

set -ex

if [ "$#" -ne 1 ]
then
    echo "This script requires one parameter: TARGET_DIR"
    exit 1
fi

# get the time - this will be used as the name of the directory
TIME_TAG=`date +"%y%m%d_%H%M%S"`

echo "Copying deployment scripts where they belong (v. $TIME_TAG)"

TARGET_DIR=$1

echo "TARGET_DIR: $TARGET_DIR"

# Move scripts only to new release directory
mkdir -p $TARGET_DIR/releases/$TIME_TAG
mv hhbd-* $TARGET_DIR/releases/$TIME_TAG

# Remove previous
rm $TARGET_DIR/releases/previous

# Move current to previous
cp -r $TARGET_DIR/releases/current $TARGET_DIR/releases/previous

# Update current link
ln -sfn $TARGET_DIR/releases/$TIME_TAG $TARGET_DIR/releases/current
