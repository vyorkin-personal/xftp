module XFTP
  module Session
    # @abstract Base class for xftp session adapters
    # @param [Hash] settings the adapter connection settings
    # @api private
    class Base
      attr_reader :uri, :login, :password

      def initialize(settings = {})
        url = settings.delete(:url)
        credentials = settings.delete(:credentials)

        @uri = URI.parse(url)
        @login = credentials[:login]
        @password = credentials[:password]
      end

      def start
        open
        yield self
        close
      end
    end
  end
end
