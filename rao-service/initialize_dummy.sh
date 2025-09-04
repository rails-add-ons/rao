#!/bin/bash
GEM_NAME=${PWD##*/}
INSTALL_NAME=${GEM_NAME//rao-/rao\:}

# Delete old dummy app
rm -rf spec/dummy

# Generate new dummy app
DISABLE_MIGRATE=true bundle exec rake dummy:app

# Fix ruby versions for rvm
rm spec/dummy/Gemfile
rm spec/dummy/.ruby-version

# Comment out all config.assets.* lines for Rails 8.0 compatibility
find spec/dummy/config -name "*.rb" -exec sed -i 's/.*config\.assets\./# &/g' {} \;


# Satisfy prerequisites
cd spec/dummy

# Use correct Gemfile
sed -i "s|../Gemfile|../../../Gemfile|g" config/boot.rb

# Install
rails generate $INSTALL_NAME:install
rails db:migrate db:test:prepare
