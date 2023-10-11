# Rails Add-Ons Service

Rails is missing a service layer. For simple applications the default MVC impementation may be enought, but once you begin adding serious business lovgic you either end up with fat controllers, models, callback hell or all of them.

Rao::Service solves this problem by providing you a service object that is easy to use. It can be simultaneously used for UIs and APIs by using Rao::ServiceController and Rao::Api::Service Controller as its frontend.


## Usage

Here is a basic example that queries the nasa api:
```
# nethttp.rb
require 'uri'
require 'net/http'

class NasaService < Rao::Service::Base
  class Result < Rao::Service::Result::Base
    attr_accessor :response

    def parsed_response
      @parsed_response ||= JSON.parse(response)
    end
  end

  private

  def _perform
    response = Net::HTTP.get_response(uri)

    if response.is_a?(Net::HTTPSuccess)
      @result.response = response.body
    else
      add_error_and_say(:base, "API request failed.")
    end
  end

  def uri
    @uri ||= URI('https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY')
  end
end

result = PlanetService.call

if result.ok?
  result.parsed_response
else
  result.errors.full_messages.to_sentence
end
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'rao-service'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install rao-service
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
