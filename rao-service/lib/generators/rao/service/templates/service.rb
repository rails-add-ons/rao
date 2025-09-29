class <%= class_name %> < Rao::Service::Base
  class Result < Rao::Service::Result::Base
<% if result_attr_accessors.present? %>
<%= result_attr_accessors %>
<% else %>
    # attr_accessor :name
<% end %>
  end

<% if attr_accessors.present? %>
<%= attr_accessors %>
<% else %>
  # attr_accessor :name
<% end %>

<% if validations.present? %>
<%= validations %>
<% else %>
  # validates :name, presence: true
<% end %>

  private

  def _perform
    # add business logic here
  end

  def save
    # persist changes here
  end
end