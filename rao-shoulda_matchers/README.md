# Rao::ShouldaMatchers

RSpec shoulda style matchers for REST compliant controllers.

## Setup

    # spec/support/rao-shoulda_matchers.rb
    require 'rao/shoulda/matchers'

    RSpec.configure do |config|
      config.include Rao::Shoulda::Matchers, type: :feature
    end

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rao-shoulda_matchers'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install rao-shoulda_matchers
```