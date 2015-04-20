require 'active_support/core_ext/object'
require 'active_support/core_ext/hash'

require 'configuration'
require 'xftp/version'
require 'xftp/errors'
require 'xftp/validator/settings'
require 'xftp/session/ftp'
require 'xftp/session/sftp'

require_relative 'initializers/i18n'

# The XFTP entry point (facade)
module XFTP
  include Errors

  SCHEME_ADAPTERS = {
    ftp:  XFTP::Session::FTP,
    ftps: XFTP::Session::SFTP
  }

  # Config accessor
  def self.config
    @configuration ||= Configuration.new
  end

  # For a block { |config| ... }
  # @yield the (see #config)
  def self.configure
    yield config
  end

  def self.validator
    @validator ||= Validator::Settings.new
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
    klass = adapter_class(uri.scheme)
    session = klass.new(uri, settings.deep_dup)
    session.start(&block)
  end

  private

  # Detects a session adapter class
  # @param [String, Symbol] scheme the uri scheme
  # @return [Class] session adapter class
  def self.adapter_class(scheme)
    SCHEME_ADAPTERS[scheme.to_sym] || not_supported_protocol!(scheme)
  end
end
