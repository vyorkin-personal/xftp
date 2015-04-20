require 'active_support/core_ext/hash/deep_merge'
require 'forwardable'
require 'net/ftp'

require 'xftp/session/base'

module XFTP
  module Session
    # FTP session adapter
    # @api private
    class FTP < Base
      extend Forwardable

      # Delegate methods which have the same method signature
      # directly to Net::FTP session
      def_delegators :@ftp, :chdir, :mkdir, :rmdir, :close

      # Creates an FTP session adapter instance
      # @param [URI] uri the remote uri
      # @param [Hash] settings the adapter connection settings
      def initialize(uri, settings = {})
        super

        @ftp = Net::FTP.new
        @port = uri.port || settings.delete(:port) || Net::FTP::FTP_PORT
        @credentials[:login] ||= 'anonymous'

        options = XFTP.config.ftp.deep_merge(@settings)
        options.each { |key, val| @ftp.public_send("#{key}=", val) }
      end

      # Renames (moves) a file on the server
      # @param [String] from the path to move from
      # @param [String] to the new path to move to
      def move(from, to)
        @ftp.rename(from, to)
      end

      # @see XFTP::Operations::FTP::Glob
      def glob(pattern, &callback)
        Operations::Glob.new(@ftp).call(pattern, &callback)
      end

      protected

      # Opens a new FTP connection and
      # authenticates on the remote server
      def open
        @ftp.connect(@uri.host, @port)
        @ftp.login(@credentials[:login], @credentials[:password])
      end
    end
  end
end
