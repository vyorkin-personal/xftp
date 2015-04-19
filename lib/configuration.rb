require 'net/ftp'
require 'net/ssh'

require 'active_support/configurable'

module XFTP
  # Provides a way to store and retrive configuration options
  class Configuration
    include ActiveSupport::Configurable

    config_accessor :logging do
      default_logger = lambda do
        logger = Logger.new(STDERR)
        logger.level = Logger::FATAL
      end

      rails_logger = -> { Rails.logger || default_logger.call }
      logger = defined?(Rails) ? rails_logger.call : default_logger.call

      {
        logger: logger,
        verbose: false,
        colorize: true
      }
    end

    config_accessor :ftp do
      {
        binary: true,
        passive: true,
        debug_mode: false,
        open_timeout: nil,
        resume: false
      }
    end

    config_accessor :ssh do
      {
        keepalive: true,
        keepalive_interval: 30,
        forward_agent: true,
        verbose: :error
      }
    end
  end
end
