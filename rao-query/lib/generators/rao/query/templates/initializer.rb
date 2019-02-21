Rao::Query.configure do |config|
  # Set the parameter names that will be ignored for building conditions.
  #
  # Default: config.default_query_params_exceptions = %w(sort_by sort_direction utf8 commit page locale)
  #
  config.default_query_params_exceptions = %w(sort_by sort_direction utf8 commit page locale)
end
