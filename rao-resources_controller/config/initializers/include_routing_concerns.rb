ActionDispatch::Routing::Mapper.send(:include, Rao::ResourcesController::Routing::ActsAsListConcern)
ActionDispatch::Routing::Mapper.send(:include, Rao::ResourcesController::Routing::ActsAsPublishedConcern)

