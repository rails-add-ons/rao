#!/bin/bash
GEM_NAME=${PWD##*/}
INSTALL_NAME=${GEM_NAME//rao-/rao\:}

# Delete old dummy app
rm -rf spec/dummy

# Generate new dummy app
DISABLE_MIGRATE=true rake dummy:app
rm spec/dummy/.ruby-version

# Comment out all config.assets.* lines for Rails 8.0 compatibility
find spec/dummy/config -name "*.rb" -exec sed -i 's/.*config\.assets\./# &/g' {} \;

cd spec/dummy

# Satisfy prerequisites

# Install
# rails generate $INSTALL_NAME:install