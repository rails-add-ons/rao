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
gem "rao-service", path: "../../../rao-service/"
gem "rao-api-service_controller", path: "../../../rao-api-service_controller/"

EOF

# Add rspec
sed -i '/group :development, :test do/a\\n  gem "rspec-rails"' Gemfile

# Add factory_bot_rails
sed -i '/group :development, :test do/a\\n  gem "factory_bot_rails"' Gemfile

# Install dependencies
bundle install

# Install
rails generate rao:api:service_controller:install

# Add route
sed -i '2i\  namespace :api do\n    resources :test_services, only: [:create]\n  end' config/routes.rb

# Add service
mkdir -p app/services
cat > app/services/test_service.rb << 'EOF'
class TestService < Rao::Service::Base
  class Result < Rao::Service::Result::Base
    attr_accessor :name
  end

  attr_accessor :name

  validates :name, presence: true
  
  def _perform
    @result.name = self.name
    puts "TestService#perform: #{name}"
  end
end
EOF

# Add controller
mkdir -p app/controllers/api
cat > app/controllers/api/test_services_controller.rb << 'EOF'
module Api
  class TestServicesController < Rao::Api::ServiceController::Base
    def self.service_class
      TestService
    end

    private

    def permitted_params
      params.require(:test_service).permit(:name)
    end
  end
end
EOF

# Setup database
rails db:migrate db:test:prepare
