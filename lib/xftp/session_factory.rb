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

    # Creates a session adapter object
    # @param [URI] uri the remote uri
    # @param [Hash] settings the connection settings
    # @return [XFTP::Session::FTP, XFTP::Session::FTPS] adapter instance
    def create(uri, settings)
      klass = adapter_class(uri.scheme)
      klass.new(uri, settings)
    end

    private

    # Detects a session adapter class
    # @param [String, Symbol] scheme the uri scheme
    # @return [Class] session adapter class
    def adapter_class(scheme)
      SCHEME_ADAPTERS[scheme.to_sym] || not_supported_protocol(scheme)
    end
  end
end
