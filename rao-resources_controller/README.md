# Rao Resources Controller

A comprehensive toolkit for building resourceful controllers in Rails applications with enhanced functionality beyond standard Rails scaffolding.

## Features

- **RESTful Controllers**: Full CRUD operations for both plural and singular resources
- **Pagination**: Kaminari integration with configurable defaults
- **Sorting**: SQL injection-safe sorting with customizable fields
- **Batch Operations**: Bulk actions like `destroy_many`, `publish_many`
- **Publishing System**: Toggle, publish, and unpublish resources
- **Friendly URLs**: Integration with FriendlyId
- **State Management**: AASM state machine support
- **Modern Rails**: Turbo Stream, JSON, and HTML response support

## Installation

Add to your Gemfile:

```ruby
gem "rao_resources_controller"
```

Run the installer:

```bash
rails generate rao:resources_controller:install
```

## Quick Start

### Plural Resources (Collections)

```ruby
class PostsController < ApplicationController
  include Rao::ResourcesController::Plural::ResourcesConcern
  include Rao::ResourcesController::Plural::RestActionsConcern
  include Rao::ResourcesController::KaminariConcern
  include Rao::ResourcesController::SortingConcern

  def self.resource_class
    Post
  end

  private

  def resource_params
    params.require(:post).permit(:title, :content, :published)
  end
end
```

### Singular Resources (Single Instance)

```ruby
class ProfileController < ApplicationController
  include Rao::ResourcesController::Singular::ResourcesConcern
  include Rao::ResourcesController::Singular::RestActionsConcern

  def self.resource_class
    User
  end

  private

  def load_resource
    @resource = current_user
  end

  def resource_params
    params.require(:user).permit(:name, :email, :bio)
  end
end
```

## Available Concerns

| Concern | Description |
|---------|-------------|
| `KaminariConcern` | Pagination with configurable per-page defaults |
| `SortingConcern` | SQL injection-safe sorting |
| `BatchActionsConcern` | Bulk operations on multiple records |
| `ActsAsPublishedConcern` | Publishing/unpublishing functionality |
| `FriendlyIdConcern` | SEO-friendly URLs |
| `AasmConcern` | State machine integration |
| `ActsAsListConcern` | Ordered list management |

## Configuration

```ruby
# config/initializers/rao-resources_controller.rb
Rao::ResourcesController.configure do |config|
  config.pagination_per_page_default = 25
  config.label_for_resource_proc = lambda do |resource|
    resource.try(:title) || resource.try(:name) || resource.to_s
  end
end
```

## Routes

```ruby
# config/routes.rb
resources :posts do
  post :destroy_many, on: :collection
  post :toggle_published, on: :member
  post :publish_many, on: :collection
  post :unpublish_many, on: :collection
end

# Singular resource
resource :profile
```

## Dependencies

- Rails 8.0+
- Rao (base framework)
- Responders (flash messages)
- Simple Form (forms)
- HAML Rails (templates)
- Rao Component (UI components)

## License

MIT License - see [LICENSE](LICENSE) file for details.
