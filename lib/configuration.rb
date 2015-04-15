require 'active_support/configurable'

module XFTP
  # Provides a way to store and retrive configuration options
  class Configuration
    include ActiveSupport::Configurable

    config_accessor :logging do
      {
        logger: defined?(Rails) ? Rails.logger : Logger.new(STDOUT),
        verbose: false,
        colorize: true
      }
    end
  end
end
