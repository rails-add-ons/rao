# Rails Add-Ons Query

Provides filtering and sorting of collections at controller level. Useful for
UIs or APIs that display any collection of records.

## Basic Usage

Include the concern in your controller and change you index action to use
conditions coming from the query string:

    # app/controllers/posts_controller.rb
    class PostsController < ApplicationController
      include Rao::Query::Controller::QueryConcern

      def index
        @posts = with_conditions_from_query(Post).all
      end
    end

### Using limit

### Using offset

### Using order

### Using includes

The includes parameter is used to eager load associations.

#### has many

Assume you have posts that have many comments. You can have the comments
included in your query like this:

    http://localhost:3000/posts?includes[]=comments

## Usage with rao-api-resources_controller

rao-api_resources_controller comes with support for rao-query. You just have
to include the QueryConcern to enable it. There is no need to overwrite the
index action:

    # app/controllers/posts_controller.rb
    class PostsController < Rao::Api::ResourcesController::Base
      include Rao::Query::Controller::QueryConcern

      #...
    end

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rao-query'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install rao-query
```

## Contributing

Contribution directions go here.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
