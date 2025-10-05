# Rao::ServiceController

A Rails gem that provides a complete controller framework for working with service objects. It includes RESTful actions, view templates, URL helpers, and concerns for building service-based web applications with minimal boilerplate.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rao-service_controller'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rao-service_controller

## Usage

### Basic Controller Setup

```ruby
class UsersController < ApplicationController
  include Rao::ServiceController::ServiceConcern
  include Rao::ServiceController::RestActionsConcern
  include Rao::ServiceController::InflectionsConcern
  include Rao::ServiceController::DefaultViewsConcern

  def self.service_class
    CreateUserService
  end

  private

  def service_params
    params.require(:user).permit(:email, :name, :password)
  end
end
```

### RESTful Actions

The gem provides service-oriented actions for creating and displaying service results:

```ruby
class UsersController < ApplicationController
  include Rao::ServiceController::ServiceConcern
  include Rao::ServiceController::RestActionsConcern

  def self.service_class
    CreateUserService
  end

  # Actions automatically provided:
  # - GET /users/new     -> new action (shows form)
  # - POST /users        -> create action (processes form and shows result)

  private

  def service_params
    params.require(:user).permit(:email, :name, :password)
  end
end
```

### Service Integration

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

class CreateUserService::Result < Rao::Service::Result::Base
  attr_accessor :user
end
```

### Routes Configuration

```ruby
# config/routes.rb
Rails.application.routes.draw do
  resources :users, only: [:new, :create]
end
```

### View Templates

The gem provides default view templates that you can customize:

#### New Action Template
```haml
// app/views/users/new.html.haml
.content-header
  .row
    .col
      %h1= t(".title", **inflections)

.content-body.overflow-y-auto.mb-2
  .row
    .col
      = render "form_tag"

.content-footer
  .row
    .col
      = render "new_actions", service: @service
```

#### Form Template
```haml
// app/views/users/_form_tag.html.haml
= simple_form_for @service, url: users_path, method: :post do |f|
  = render "form_fields", f: f
  = render "form_actions", f: f
```

### Internationalization

```yaml
# config/locales/en.yml
en:
  users:
    new:
      title: "Create User"
  activemodel:
    create_user_service:
      attributes:
        email: "Email Address"
        name: "Full Name"
        password: "Password"
```

### Custom Views

Override default views by creating your own templates:

```haml
// app/views/users/_form_fields.html.haml
= f.input :email, label: t("activemodel.attributes.create_user_service.email")
= f.input :name, label: t("activemodel.attributes.create_user_service.name")
= f.input :password, label: t("activemodel.attributes.create_user_service.password")
```

### URL Helpers

The gem provides URL helpers for service-based routes:

```ruby
class UsersController < ApplicationController
  include Rao::ServiceController::RestUrlsConcern

  def self.service_class
    CreateUserService
  end

  # Available helpers:
  # - new_service_path        -> /users/new
  # - service_path(options)   -> /users (with optional parameters)
end
```

### Result Display

Display service results with built-in templates:

```haml
// app/views/users/result.html.haml
.content-header
  .row
    .col
      %h1= t(".title", **inflections)

.content-body
  .row
    .col
      = render "result_table"

.content-footer
  .row
    .col
      = render "result_actions"
```

### Flash Messages

Automatic flash message handling:

```ruby
class UsersController < ApplicationController
  include Rao::ServiceController::RestActionsConcern

  def self.service_class
    CreateUserService
  end

  # Flash messages are automatically set based on service results:
  # - Success: "User created successfully"
  # - Failure: Error messages from service
end
```

### Advanced Configuration

#### Custom Service Parameters

```ruby
class UsersController < ApplicationController
  include Rao::ServiceController::RestActionsConcern

  def self.service_class
    CreateUserService
  end

  private

  def service_params
    params.require(:user).permit(:email, :name, :password, :terms_accepted)
  end

  def service_attributes
    super.merge(created_by: current_user)
  end
end
```

#### Custom Redirects

```ruby
class UsersController < ApplicationController
  include Rao::ServiceController::RestActionsConcern

  def self.service_class
    CreateUserService
  end

  private

  def after_create_success_path
    user_path(@service_result.user)
  end

  def after_create_failure_path
    new_user_path
  end
end
```

#### Custom Inflections

```ruby
class UsersController < ApplicationController
  include Rao::ServiceController::InflectionsConcern

  private

  def inflections
    super.merge(
      page_title: "User Management",
      action_button: "Create New User"
    )
  end
end
```

## Features

### Core Functionality
- **Service Integration**: Seamless integration with rao-service objects
- **RESTful Actions**: Complete CRUD operations for service-based resources
- **View Templates**: Pre-built HAML templates for forms and results
- **URL Helpers**: Automatic URL generation for service routes
- **Flash Messages**: Automatic success/error message handling

### Advanced Features
- **Inflections**: Human-readable service names and terminology
- **Internationalization**: Built-in i18n support for all text content
- **Customizable Views**: Override any template with your own customizations
- **Referrer History**: Maintain navigation history for better UX
- **Default Views**: Automatic fallback to default templates

### Rails Integration
- **ActionController**: Full Rails controller integration
- **SimpleForm**: Built-in support for SimpleForm gem
- **ActiveModel**: Compatible with ActiveModel naming conventions
- **Rails Routes**: Standard Rails routing support

## Concerns

The gem is modular and provides several concerns you can include as needed:

- `ServiceConcern`: Basic service class integration
- `RestActionsConcern`: RESTful CRUD actions
- `RestUrlsConcern`: URL helper generation
- `InflectionsConcern`: Human-readable terminology
- `DefaultViewsConcern`: Default view template fallback
- `ReferrerHistoryConcern`: Navigation history management

## View Structure

The gem provides a complete set of view templates:

```
app/views/rao/service_controller/base/
├── new.html.haml              # New resource form
├── result.html.haml           # Result display
├── _form_tag.html.haml        # Form wrapper
├── _form_fields.html.haml     # Form fields
├── _form_actions.html.haml    # Form submit buttons
├── _form_errors.html.haml     # Error display
├── _result_table.html.haml    # Result table
├── _result_actions.html.haml  # Result action buttons
├── _new_actions.html.haml     # New page actions
└── _flash.html.haml           # Flash message display
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rao/rao-service_controller.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
