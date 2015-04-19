require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/deep_dup'

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

  def self.validator
    @validator ||= Validator::Settings.new
  end

  def self.factory
    @factory ||= SessionFactory.new
  end

  # For a block { |config| ... }
  # @yield the (see #config)
  def self.configure
    yield config
  end

  # Initiates a new session
  #
  # @param [String] :url the remote host url
  # @param [Hash] settings the connection settings
  # @option settings [Hash<Symbol, String>] :credentials the authentication credentials
  #
  # @raise [URI::InvalidURIError] if url given is not a correct URI
  # @raise [XFTP::MissingArgument] if some of the required settings are missing
  # @raise [XFTP::NotSupportedProtocol] if protocol detected by schema is not supported
  #
  # @see Net::SSH
  # @see Net::FTP
  #
  # @see XFTP::Validator::Settings
  def self.start(url, settings = {}, &block)
    uri = URI.parse(url)
    validator.call!(uri, settings)
    session = factory.create(uri, settings.deep_dup)
    session.start(&block)
  end
end
