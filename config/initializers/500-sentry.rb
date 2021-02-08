# frozen_string_literal: true

Raven.configure do |config|
  app_name = ENV['HEROKU_APP_NAME']
  release_version = ENV['HEROKU_RELEASE_VERSION']

  config.dsn = ENV['SENTRY_DSN']
  if app_name && release_version
    config.release = "#{app_name}@#{release_version}"
  end
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
end
