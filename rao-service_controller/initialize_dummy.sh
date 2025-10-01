#!/bin/bash

# Delete old dummy app
rm -rf spec/dummy

# Generate new dummy app
CURRENT_DIR=$(pwd)
TEMP_DIR=$(mktemp -d)
cd $TEMP_DIR
rails --version
rails new dummy \
  --skip-git \
  --skip-bundle \
  -T \
  --javascript=importmap
mv dummy $CURRENT_DIR/spec/dummy
cd $CURRENT_DIR
rm -rf $TEMP_DIR

# Abort unless the dummy app was created successfully
if [ ! -d "spec/dummy" ]; then
  echo "Dummy app was not created successfully"
  exit 1
fi

# Proceed in the dummy app
cd spec/dummy

# Remove .ruby-version
rm .ruby-version

# In boot.rb use the Gemfile from the root directory
sed -i 's|../Gemfile|../../../Gemfile|' config/boot.rb

# Remove Gemfile*
rm Gemfile*

# install importmaps
bin/rails importmap:install

# install turbo-rails
bin/rails turbo:install

# Install rao-component
bin/rails g rao:component:install
bin/rails g rao:component:flash

# Install
bin/rails generate rao:service_controller:install

# Setup dummy app services
bin/rails g rao:service_controller:scaffold TestService name:string

# Setup database
bin/rails db:migrate db:test:prepare
