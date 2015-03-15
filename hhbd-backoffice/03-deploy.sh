#!/bin/bash

set -ex

if [ "$#" -ne 2 ]
then
    echo "This script requires two parameters: target_server and deployer_user_name"
    exit 1
fi

# get the time - this will be used as the name of the directory
TIME_TAG=`date +"%y%m%d_%H%M%S"`
PACKAGE_NAME=package-hhbd-app-$TIME_TAG.tar.gz
TARGET_SERVER=$1
DEPLOYMENT_USER=$2

echo "$DEPLOYMENT_USER deploys $TIME_TAG to $TARGET_SERVER"

# Compress all content of the directory
tar -czf /tmp/$PACKAGE_NAME *

TARGET_DIR=/var/www/hhbd-app

# Copy package
scp /tmp/$PACKAGE_NAME $DEPLOYMENT_USER@$TARGET_SERVER:/tmp

# Run multiple commands over SSH
ssh $DEPLOYMENT_USER@$TARGET_SERVER /bin/bash << EOF

    # Create directory for new release
    mkdir $TARGET_DIR/releases/$TIME_TAG

    # Extract package to new release directory
    tar xzf /tmp/$PACKAGE_NAME -C $TARGET_DIR/releases/$TIME_TAG

    # Copy configuration from current
    cp $TARGET_DIR/releases/current/config/config.local.neon $TARGET_DIR/releases/$TIME_TAG/config/config.local.neon

    # Remove previous
    rm -r $TARGET_DIR/releases/previous

    # Copy current to previous
    cp -r $TARGET_DIR/releases/current $TARGET_DIR/releases/previous

    # Update symbolic link to point to newest release
    ln -sfn $TARGET_DIR/releases/$TIME_TAG $TARGET_DIR/releases/current

EOF
