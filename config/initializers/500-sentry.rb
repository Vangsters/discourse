# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = ENV['SENTRY_DSN']

  app_name = ENV['HEROKU_APP_NAME']
  release_version = ENV['HEROKU_RELEASE_VERSION']
  if app_name && release_version
    config.release = "#{app_name}@#{release_version}"
  end

  # Provide Rails-specific breadcrumbs in errors
  config.breadcrumbs_logger = [:active_support_logger]

  # Enable performance monitoring
  config.traces_sample_rate = 0.5

  # Filter sensitive data out of error
  filter = ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters)
  config.before_send = lambda do |event, hint|
    filter.filter(event.to_hash)
  end

  # Send error to Sentry in the background
  config.async = lambda do |event, hint|
    Sentry::SendEventJob.perform_later(event, hint)
  end
end
