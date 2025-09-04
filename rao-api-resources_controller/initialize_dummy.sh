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
rails generate rao:api:resources_controller:install

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

# Setup database
rails db:migrate db:test:prepare
