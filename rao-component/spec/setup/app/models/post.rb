class Post < ApplicationRecord
  include ActsAsPublished::ActiveRecord
  acts_as_list
  acts_as_published

  default_scope { order(position: :asc) }
end