#!/bin/bash

set -ex

# get the time - this will be used as the name of the directory
TIME_TAG=`date +"%y%m%d_%H%M%S"`

echo "Copying deployment scripts where they belong (v. $TIME_TAG)"

TARGET_DIR=/home/strider

# Move scripts only to new release directory
mv hhbd-* $TARGET_DIR/scripts/releases/$TIME_TAG

# Remove previous
rm $TARGET_DIR/scripts/releases/previous

# Move current to previous
cp -r $TARGET_DIR/scripts/releases/current $TARGET_DIR/scripts/releases/previous

# Update current link
ln -sfn $TARGET_DIR/scripts/releases/$TIME_TAG $TARGET_DIR/scripts/releases/current
