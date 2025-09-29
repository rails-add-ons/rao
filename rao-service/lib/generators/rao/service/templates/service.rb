class <%= class_name %> < Rao::Service::Base
  class Result < Rao::Service::Result::Base
    # attr_accessor :name
  end

  # attr_accessor :name

  # validates :name, presence: true

  private

  def _perform
    # add business logic here
  end

  def save
    # persist changes here
  end
end