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
