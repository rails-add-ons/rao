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

# install importmaps
bin/rails importmap:install

# install turbo-rails
bin/rails turbo:install

# Add rao from local path by appending to Gemfile
cat >> Gemfile << 'EOF'

gem "rao", path: "../../../"
gem "rao-view_helper", path: "../../../rao-view_helper/"
gem "rao-query", path: "../../../rao-query/"

EOF

# Add rspec
sed -i '/group :development, :test do/a\\n  gem "rspec-rails"' Gemfile

# Add factory_bot_rails
sed -i '/group :development, :test do/a\\n  gem "factory_bot_rails"' Gemfile

# Install dependencies
bundle install

# Setup specs
rails g model post title body:text published_at:timestamp

# Install
rails generate rao:query:install

# Setup database
rails db:migrate db:test:prepare
