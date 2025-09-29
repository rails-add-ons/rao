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
gem "rao-component", path: "../../../rao-component/"
gem "rao-resources_controller", path: "../../../rao-resources_controller/"

EOF

# Add rspec
sed -i '/group :development, :test do/a\\n  gem "rspec-rails"' Gemfile

# Add factory_bot_rails
sed -i '/group :development, :test do/a\\n  gem "factory_bot_rails"' Gemfile

# Install dependencies
bundle install

# Install
rails generate rao:resources_controller:install

# Generate home index page and route root to it
rails g controller home index
sed -i '2i\  root to: "home#index"' config/routes.rb

# Generate models
rails g model post title body:text published_at:timestamp
rails g model user name email bio
rm -rf spec/helpers
rm -rf spec/models
rm -rf spec/views

# Add route
sed -i '2i\  resources :posts\n  resource :user\n  resolve("User") { [:user] }' config/routes.rb 

# Add flash helper
sed -i '2i\  helper Rao::Component::FlashHelper' app/controllers/application_controller.rb

# render flash in application layout before <%= yield %>
sed -i '/<%= yield %>/i\    <%= flash_messages.render %>' app/views/layouts/application.html.erb

# Copy all files from spec/setup to dummy app
cp -r $CURRENT_DIR/spec/setup/. .

# Setup database
rails db:migrate db:test:prepare
