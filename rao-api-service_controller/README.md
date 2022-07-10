# Rao::Api:ServiceController

Short description and motivation.

## Usage

How to use my plugin.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rao-api-service_controller'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install rao-api-service_controller
```

Generate the initializer:

```bash
$ rails g rao:api:service_controller:install
```

## Customizing the initialization of the service

The service is initialized in the initialize_service_for_create method before
it is called/performed.

If you want to do things with the service before it gets called you can override
this method in you controller:

      # app/controller/import_services_controller.rb
      class ImportServicesController < ApplicationServicesController
        #...

        private

        def initialize_service_for_create
          super
          @service.current_user_id = session['current_user_id']
        end
      end

## Contributing

Contribution directions go here.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
