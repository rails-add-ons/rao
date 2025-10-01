module Rao
  module ResourcesController
   class ResourceViewHelper < Rao::ViewHelper::Base
     def label_for(resource)
       Rao::ResourcesController::Configuration.label_for_resource_proc.call(resource)
      end
    end
  end
end
