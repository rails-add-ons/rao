class Post < Rao::ActiveCollection::Base
  attr_accessor :id, :title

  validates :title, presence: true
end
