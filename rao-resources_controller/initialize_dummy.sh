#!/bin/bash
GEM_NAME=${PWD##*/}
INSTALL_NAME=${GEM_NAME//rao-/rao\:}

# Delete old dummy app
rm -rf spec/dummy

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

# # Generate new dummy app
# DISABLE_MIGRATE=true bundle exec rake dummy:app
# 
# # Fix ruby versions for rvm
# rm spec/dummy/Gemfile
# rm spec/dummy/.ruby-version
# 
# # Comment out all config.assets.* lines for Rails 8.0 compatibility
# find spec/dummy/config -name "*.rb" -exec sed -i 's/.*config\.assets\./# &/g' {} \;

# Satisfy prerequisites
cd spec/dummy

# Remove .ruby-version
rm .ruby-version

# install importmaps
bin/rails importmap:install

# install turbo-rails
bin/rails turbo:install

# Use correct Gemfile
# sed -i "s|../Gemfile|../../../Gemfile|g" config/boot.rb

# Add rao from local path by appending to Gemfile
cat >> Gemfile << 'EOF'

gem "rao", path: "../../../"
gem "rao-component", path: "../../../rao-component"
gem "rao-resources_controller", path: "../../../rao-resources_controller"

EOF

# Add rspec
sed -i '/group :development, :test do/a\\n  gem "rspec-rails"' Gemfile

# Add factory_bot_rails
sed -i '/group :development, :test do/a\\n  gem "factory_bot_rails"' Gemfile
bundle install

# Install (if generator exists)
# rails generate $INSTALL_NAME:install || true

# Generate home index page and route root to it
rails g controller home index
sed -i '2i\  root to: "home#index"' config/routes.rb

# Generate models
rails g model post title body:text published_at:timestamp
rails g model user name email bio

# Add route
sed -i '2i\  resources :posts\n  resource :user\n  resolve("User") { [:user] }' config/routes.rb 

# Add flash helper
sed -i '2i\  helper Rao::Component::FlashHelper' app/controllers/application_controller.rb

# render flash in application layout before <%= yield %>
sed -i '/<%= yield %>/i\    <%= flash_messages.render %>' app/views/layouts/application.html.erb

# Create controllers
mkdir -p app/controllers
cat > app/controllers/posts_controller.rb << 'EOF'
class PostsController < ApplicationController
  include Rao::ResourcesController::ResourceInflectionsConcern
  include Rao::ResourcesController::DefaultViewsConcern
  include Rao::ResourcesController::Plural::RestResourcesUrlsConcern
  include Rao::ResourcesController::Plural::ResourcesConcern
  include Rao::ResourcesController::Plural::RestActionsConcern

  def self.resource_class
    Post
  end

  private

  def resource_params
    params.require(:post).permit(:title, :body)
  end
end
EOF

cat > app/controllers/users_controller.rb << 'EOF'
class UsersController < ApplicationController
  include Rao::ResourcesController::ResourceInflectionsConcern
  include Rao::ResourcesController::DefaultViewsConcern
  include Rao::ResourcesController::Singular::RestResourcesUrlsConcern
  include Rao::ResourcesController::Singular::ResourcesConcern
  include Rao::ResourcesController::Singular::RestActionsConcern

  def self.resource_class
    User
  end

  private

  def load_resource
    @resource = User.first
  end

  def resource_params
    params.require(:user).permit(:name, :email, :bio)
  end
end
EOF

# Setup database
rails db:migrate db:test:prepare
