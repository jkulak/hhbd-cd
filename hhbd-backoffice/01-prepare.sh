#!/bin/bash

# These commands are run after the repo is cloned but before the tests.
# Installing dependencies is a good example.

# Strider prepare hhbd-app script

set -ex

cd admin && composer install
cd ../xadmin && composer install
