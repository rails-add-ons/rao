require 'rao'
require 'rao/shoulda_matchers/version'

module Rao
  # Adding the matchers to rspec:
  #
  #     # spec/rails_helper or spec/support/rao-shoulda_matchers.rb
  #     require 'rao/shoulda/matchers'
  #     
  #     RSpec.configure do |config|
  #       config.include Rao::Shoulda::Matchers, type: :feature
  #     end
  module ShouldaMatchers
  end
end
