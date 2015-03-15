#!/bin/bash

# Define target server for selected branch - done in Strider Environment Variables
# TARGET_SERVER='new.hhbd.pl'

# Define target directory - done in Strider Environment Variables
# TARGET_DIR=/var/www/new.hhbd.pl

set -ex

# get the time - this will be used as the name of the directory
TIME_TAG=`date +"%y%m%d_%H%M%S"`
PACKAGE_NAME=package-hhbd-app-$TIME_TAG.tar.gz

# Compress all content of the directory
tar -czf /tmp/$PACKAGE_NAME *

# Copy package
scp /tmp/$PACKAGE_NAME $TARGET_SERVER:/tmp

# Run multiple commands over SSH
ssh $TARGET_SERVER /bin/bash << EOF

    # Create directory for new release
    mkdir $TARGET_DIR/releases/$TIME_TAG

    # Extract package to new release directory
    tar xzf /tmp/$PACKAGE_NAME -C $TARGET_DIR/releases/$TIME_TAG

    # Copy configuration from current
    cp $TARGET_DIR/releases/current/application/configs/application.ini $TARGET_DIR/releases/$TIME_TAG/application/configs/application.ini

    # Remove previous
    rm -r $TARGET_DIR/releases/previous

    # Copy current to previous
    cp -r $TARGET_DIR/releases/current $TARGET_DIR/releases/previous

    # Update symbolic link to point to newest release
    ln -sfn $TARGET_DIR/releases/$TIME_TAG $TARGET_DIR/releases/current

EOF
