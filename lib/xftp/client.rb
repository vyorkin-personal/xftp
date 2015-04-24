require 'xftp/session/ftp'
require 'xftp/session/sftp'

module XFTP
  # The XFTP entry point
  # @api private
  class Client
    SCHEME_ADAPTERS = {
      ftp:  XFTP::Session::FTP,
      ftps: XFTP::Session::SFTP
    }

    def self.start(url, settings, &callback)
      new(SCHEME_ADAPTERS).call(url, settings, &callback)
    end

    def initialize(scheme_adapters)
      @scheme_adapters = scheme_adapters
    end

    # Initiates a new session
    # @see XFTP::Validator::Settings
    def call(url, settings, &block)
      uri = URI.parse(url)
      klass = adapter_class(uri.scheme)
      session = klass.new(uri, settings.deep_dup)
      session.start(&block)
    end

    private

    # Detects a session adapter class
    # @param [String, Symbol] scheme the uri scheme
    # @return [Class] session adapter class
    def adapter_class(scheme)
      @scheme_adapters.fetch(scheme.to_sym) do
        fail NotSupportedProtocol, "Not supported protocol '#{scheme}'"
      end
    end
  end
end
