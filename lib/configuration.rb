require 'net/ftp'
require 'net/ssh'

require 'active_support/configurable'

module XFTP
  # Provides a way to store and retrive configuration options
  class Configuration
    include ActiveSupport::Configurable

    class << self
      # HACK: This is required to smooth a future transition to activesupport 4.x
      # Since 3-2's config_accessor doesn't take a block or provide an option to set the default value of a config.
      alias_method :old_config_accessor, :config_accessor

      def config_accessor(*names)
        old_config_accessor(*names)
        return unless block_given?

        names.each do |name|
          send("#{name}=", yield)
        end
      end
    end

    config_accessor :logger do
      rails_logger = -> { Rails.logger || default_logger.call }
      defined?(Rails) ? rails_logger.call : Logger.new(STDOUT)
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
