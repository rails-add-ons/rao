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
gem "rao-api-resources_controller", path: "../../../rao-api-resources_controller/"

EOF

# Add rspec
sed -i '/group :development, :test do/a\\n  gem "rspec-rails"' Gemfile

# Add factory_bot_rails
sed -i '/group :development, :test do/a\\n  gem "factory_bot_rails"' Gemfile

# Install dependencies
bundle install

# Setup dummy app models
rails g model post title body:text published_at:timestamp

# Add route
sed -i '2i\  namespace :api do\n    resources :posts\n  end' config/routes.rb

# Add controller
mkdir -p app/controllers/api
cat > app/controllers/api/posts_controller.rb << 'EOF'
module Api
  class PostsController < Rao::Api::ResourcesController::Base
    def self.resource_class
      Post
    end
  end
end
EOF

# Install
rails generate rao:api:resources_controller:install

# Setup database
rails db:migrate db:test:prepare
