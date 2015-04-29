require 'active_support/core_ext/object'
require 'active_support/core_ext/hash'

require 'configuration'
require 'xftp/version'
require 'xftp/errors'
require 'xftp/client'

require_relative 'initializers/i18n'

# Interface unification for FTP/SFTP protocols
module XFTP
  # Config accessor
  def self.config
    @configuration ||= Configuration.new
  end

  # Calls the given block using temporary configuration
  # :reek:TooManyStatements
  def self.using(logger: config.logger, ftp: config.ftp, ssh: config.ssh)
    snapshot = config.clone
    config.logger = logger
    config.ftp = ftp
    config.ssh = ssh
    yield
    @configuration = snapshot
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
  def self.start(url, settings = {}, &callback)
    Client.start(url, settings, &callback)
  end
end
