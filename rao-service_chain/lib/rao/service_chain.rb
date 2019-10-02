require "rao/service_chain/version"
require "rao/service_chain/configuration"
require "rao/service_chain/engine"

module Rao
  module ServiceChain
    extend Configuration
  end
end

Rao.configure { |c| c.register_configuration(:service_chain, Rao::ServiceChain) }