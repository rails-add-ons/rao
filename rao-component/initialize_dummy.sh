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
# replace ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)
# with ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../../../Gemfile", __dir__)
sed -i 's|../Gemfile|../../../Gemfile|' config/boot.rb

# Remove Gemfile*
rm Gemfile*

# Add requires to application.rb (acts_as_list and rao-resources_controller)
sed -i '/require "rails"/a\\nrequire "acts_as_list"' config/application.rb
sed -i '/require "rails"/a\\nrequire "rao-resources_controller"' config/application.rb
sed -i '/require "rails"/a\\nrequire "ostruct"' config/application.rb

# install importmaps
bin/rails importmap:install

# Add rao-component to importmap
echo 'pin "rao-component", to: "rao-component/application.js"' >> config/importmap.rb

# Add rao-component import to application.js
echo 'import "rao-component"' >> app/javascript/application.js

# install turbo-rails
bin/rails turbo:install

# Install
rails generate rao:component:install

# Setup dummy app
rails g scaffold Post title body:text published_at:timestamp position:integer --skip-test-framework
rails g factory_bot:model Post title body:text published_at:timestamp position:integer

# Setup database
rails db:migrate db:test:prepare

# Add acts_as_list to Post model
sed -i '/class Post < ApplicationRecord/a\\n  acts_as_list' app/models/post.rb

# Add acts_as_list routes to posts by replacing resources :posts
sed -i 's/resources :posts/resources :posts do\n    post :reposition, on: :member\n  end/' config/routes.rb

# Add acts_as_list controller to posts
sed -i '/class PostsController < ApplicationController/a\\n  include Rao::ResourcesController::ActsAsListConcern' app/controllers/posts_controller.rb

# Create posts
bin/rails runner "require 'factory_bot_rails'; FactoryBot.create_list(:post, 10)"

# Create OpenStructs routes/controller/views
rails generate controller OpenStructs index show

# Create Options routes/controller/views
rails generate controller Options index show

# Overwrite posts index/show views
cp $CURRENT_DIR/spec/setup/app/views/posts/index.html.haml ./app/views/posts/index.html.haml
cp $CURRENT_DIR/spec/setup/app/views/posts/show.html.haml ./app/views/posts/show.html.haml
cp $CURRENT_DIR/spec/setup/app/views/open_structs/index.html.haml ./app/views/open_structs/index.html.haml
cp $CURRENT_DIR/spec/setup/app/views/open_structs/show.html.haml ./app/views/open_structs/show.html.haml
cp $CURRENT_DIR/spec/setup/app/views/options/index.html.haml ./app/views/options/index.html.haml