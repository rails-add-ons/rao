Rao::Service.configure do |config|
  # Set the default recipient for service result emails.
  #
  # Default: config.default_notification_sender = 'john.doe@domain.local'
  #
  config.default_notification_sender = 'john.doe@domain.local'

  # Set the default recipient for service result emails.
  #
  # Default: config.default_notification_recipient = 'john.doe@domain.local'
  #
  config.default_notification_recipient = 'john.doe@domain.local'

  # Set the environment that will be shown in notifications.
  #
  # Default: config.default_notification_recipient = ->(result) { ::Rails.env }
  #
  config.notification_environment = ->(result) { ::Rails.env }
end
