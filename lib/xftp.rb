require 'active_support/core_ext/object/blank'
require 'active_support/concern'

require 'xftp/version'
require 'xftp/errors'
require 'xftp/validator/connection_settings'
require 'xftp/session_factory'

require_relative 'initializers/i18n'

# The XFTP entry point (facade)
module XFTP
  # Config accessor
  def self.config
    @configuration ||= Configuration.new
  end

  # For a block { |config| ... }
  # @yield the (see #config)
  def self.configure
    yield config
  end

  # Initiates a new session
  # @param [Hash] settings the connection settings
  # @option settings [String] :url the host url including scheme
  # @option settings [Hash<Symbol, String>] :credentials
  # @raise [XFTP::MissingArgument] if some of the required settings are missing
  # @raise [XFTP::NotSupportedProtocol] if protocol detected by schema is not supported
  def self.start(settings, &block)
    session = SessionFactory.create(settings)
    session.start(&block)
  end
end
