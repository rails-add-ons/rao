# Rao::Service

A powerful Ruby gem that provides a standardized framework for implementing service objects with comprehensive functionality including callbacks, validation, error handling, message logging, JSON serialization, and background job processing.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rao-service'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rao-service

## Usage

### Basic Service Implementation

```ruby
class CreateUserService < Rao::Service::Base
  attr_accessor :email, :name, :password

  private

  def _perform
    @user = User.new(email: email, name: name, password: password)
    
    if @user.save
      add_message("User created successfully")
      result.user = @user
    else
      add_errors(@user.errors)
    end
  end
end

# Usage
result = CreateUserService.call(
  email: "user@example.com",
  name: "John Doe",
  password: "secret123"
)

if result.success?
  puts "Created user: #{result.user.name}"
else
  puts "Errors: #{result.errors.full_messages.join(', ')}"
end
```

### Service with Callbacks

```ruby
class ProcessOrderService < Rao::Service::Base
  attr_accessor :order_id

  def before_perform
    say "Starting order processing..."
  end

  def after_perform
    say "Order processing completed"
  end

  def around_perform
    say "Processing order #{order_id}" do
      yield
    end
  end

  private

  def _perform
    order = Order.find(order_id)
    order.process!
    result.order = order
  end
end
```

### Background Job Processing

```ruby
class SendEmailService < Rao::Service::Base
  attr_accessor :recipient, :subject, :body

  private

  def _perform
    Mailer.send_email(recipient, subject, body).deliver_now
    add_message("Email sent successfully")
  end
end

# Enqueue for background execution
SendEmailService.call_later(
  recipient: "user@example.com",
  subject: "Welcome!",
  body: "Welcome to our service!"
)

# With autosave enabled
SendEmailService.call_later!(
  recipient: "user@example.com",
  subject: "Welcome!",
  body: "Welcome to our service!"
)
```

### Custom Result Classes

```ruby
class CreateUserService::Result < Rao::Service::Result::Base
  attr_accessor :user, :confirmation_sent, :welcome_email_sent

  def initialize(service)
    super
    @confirmation_sent = false
    @welcome_email_sent = false
  end
end

class CreateUserService < Rao::Service::Base
  attr_accessor :email, :name

  private

  def _perform
    @user = User.create!(email: email, name: name)
    send_confirmation_email
    send_welcome_email
    
    result.user = @user
    result.confirmation_sent = true
    result.welcome_email_sent = true
  end

  def send_confirmation_email
    # Email logic here
  end

  def send_welcome_email
    # Email logic here
  end
end
```

### Error Handling

```ruby
class ValidateUserService < Rao::Service::Base
  attr_accessor :email, :name

  private

  def _perform
    validate_email
    validate_name
    
    return if errors.any?
    
    add_message("Validation passed")
  end

  def validate_email
    if email.blank?
      add_error(:email, "Email is required")
    elsif !email.include?("@")
      add_error_and_say(:email, "Invalid email format")
    end
  end

  def validate_name
    if name.blank?
      add_error(:name, "Name is required")
    elsif name.length < 2
      add_error(:name, "Name must be at least 2 characters")
    end
  end
end
```

### JSON Serialization

```ruby
result = CreateUserService.call(email: "user@example.com", name: "John")
result.as_json
# => {
#   messages: ["User created successfully"],
#   errors: [],
#   user: { id: 1, email: "user@example.com", name: "John" }
# }
```

### Autosave Functionality

```ruby
class CreateUserWithProfileService < Rao::Service::Base
  attr_accessor :user_data, :profile_data

  private

  def _perform
    @user = User.new(user_data)
    @profile = @user.build_profile(profile_data)
    
    result.user = @user
    result.profile = @profile
  end

  def save
    ActiveRecord::Base.transaction do
      @result.user.save!
      @result.profile.save!
    end
  end
end

# Automatically saves @user and @profile after successful execution
result = CreateUserWithProfileService.call!(
  user_data: { name: "John" },
  profile_data: { bio: "Software developer" }
)
```

## Features

### Core Functionality
- **Service Objects**: Clean, organized business logic encapsulation
- **Callbacks**: Lifecycle hooks for before/after/around execution
- **Error Handling**: Comprehensive error collection and validation
- **Message Logging**: Structured logging with indentation and grouping
- **Result Objects**: Standardized return values with success/failure state
- **JSON Serialization**: Clean serialization with circular reference protection

### Advanced Features
- **Background Jobs**: ActiveJob integration for async processing
- **Autosave**: Automatic model saving after successful execution
- **Internationalization**: Built-in i18n support for messages and errors
- **Email Notifications**: Automatic email notifications for service results
- **Attribute Management**: Dynamic attribute tracking and serialization

### Rails Integration
- **ActiveModel**: Full ActiveModel integration for validations and naming
- **ActionMailer**: Email notification support
- **ActiveJob**: Background job processing
- **Form Helpers**: Compatible with Rails form helpers and routing

## Configuration

```ruby
# config/initializers/rao_service.rb
Rao::Service.configure do |config|
  config.default_notification_sender = "noreply@example.com"
  config.default_notification_recipient = "admin@example.com"
  config.notification_environment = ->(result) { Rails.env }
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rao/rao-service.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
