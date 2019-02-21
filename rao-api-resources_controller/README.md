# Rao::Api:ServiceController
Short description and motivation.

## Usage

### Basic example

We are going to add a REST api to a basic rails model.

Assume you have a Post model:

```ruby
# app/models/post.rb
class Post < ApplicationRecord
end
```

To add an api endpoint at /api/posts we will need routes and an api controller.

First the routes:

```ruby
# config/routes.rb
Rails.application.routes.draw do
  namespace :api do
    resources :posts
  end
end
```

Then the controller:

```ruby
# app/controllers/api/posts_controller.rb
module Api
  class PostsController < Rao::Api::ResourcesController::Base
    # Here we specify the model class this controller is for.
    def self.resource_class
      Post
    end
  end
end
```


## Installation
Add this line to your application's Gemfile:

```ruby
gem 'rao-api-resources_controller'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install rao-api-resources_controller
```

Generate the initializer:

```bash
$ rails g rao:api:resources_controller:install
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
