# Rails Add-Ons Component
Short description and motivation.

## Usage
How to use my plugin.

## Adding acts_as_list support for collection tables.

To use this feature you have to add coffee-rails, jquery-rails and jquery-ui-rails gems to your applicaiton.

If you want to have sortable items via acts_as_list and drag and drop, you have to add the javascript to your
application:

```
   // app/assets/javascripts/applicaiton.js
   //= require jquery
   //= require jquery-ui
   //= require rao-component/acts_as_list
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'rao-component'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install rao-component
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
