# Rails Add-Ons Component
Short description and motivation.

## Usage
How to use my plugin.

## Adding acts_as_list support for collection tables.

The component now uses modern vanilla JavaScript with the HTML5 Drag and Drop API - no external dependencies required!

If you want to have sortable items via acts_as_list and drag and drop, the functionality is automatically included when you import the rao-component:

```javascript
   // app/javascript/application.js
   import "rao-component/application"
```

The drag and drop functionality supports both `acts_as_list` and `awesome_nested_set` patterns with scoped drag operations and visual feedback.

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
