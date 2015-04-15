require 'uri'

require 'xftp/session/ftp'
require 'xftp/session/sftp'

module XFTP
  # Knows how to create a session adapter
  # @api private
  class SessionFactory
    include Errors

    SCHEME_ADAPTERS = {
      ftp:  XFTP::Session::FTP,
      ftps: XFTP::Session::SFTP
    }

    def initialize
      @validator = Validator::ConnectionSettings.new
    end

    # Creates a session adapter
    # @param [Hash] settings the connection settings
    # @return [XFTP::Session::FTP, XFTP::Session::FTPS] adapter instance
    # @raise [XFTP::MissingArgument] if some of the required settings are missing
    # @see XFTP::Validator::ConnectionSettings
    def create(settings)
      @validator.validate!(settings)
      klass = adapter_class(settings)
      klass.new(settings)
    end

    # Detects a session adapter class
    # @return [Class] session adapter class
    def adapter_class(settings)
      uri = URI.parse(settings[:url])
      scheme = uri.scheme.to_sym
      not_supported_protocol!(scheme) unless SCHEME_ADAPTERS.keys.include?(protocol)
      SCHEME_ADAPTERS[scheme]
    end
  end
end
