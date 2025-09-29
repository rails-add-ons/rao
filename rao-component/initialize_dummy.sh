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

# Add requires to application.rb
sed -i '/require "rails"/a\\nrequire "acts_as_list"' config/application.rb
sed -i '/require "rails"/a\\nrequire "acts_as_published"' config/application.rb
sed -i '/require "rails"/a\\nrequire "rao-resources_controller"' config/application.rb
sed -i '/require "rails"/a\\nrequire "ostruct"' config/application.rb

# install importmaps
bin/rails importmap:install

# install turbo-rails
bin/rails turbo:install

# Setup dummy app
rails g scaffold Post title body:text published_at:timestamp position:integer --skip-test-framework
rails g factory_bot:model Post title body:text published_at:timestamp position:integer

# Setup database
rails db:migrate db:test:prepare

# Add acts_as_list and acts_as_published routes to posts by replacing resources :posts
sed -i 's/resources :posts/resources :posts do\n    post :reposition, on: :member\n    post :toggle_published, on: :member\n  end/' config/routes.rb

# Create posts
bin/rails runner "require 'factory_bot_rails'; FactoryBot.create_list(:post, 10)"

# Create OpenStructs routes/controller/views
rails generate controller OpenStructs index show

# Create Options routes/controller/views
rails generate controller Options index show

# Copy all files from spec/setup to dummy app
cp -r $CURRENT_DIR/spec/setup/. .

# Cleanup
rm -rf spec/helpers
rm -rf spec/views

# Install rao-component
rails generate rao:component:install
