require 'xftp/session/base'
require 'forwardable'
require 'net/ftp'

module XFTP
  module Session
    # FTP session adapter
    # @api private
    class FTP < Base
      extend Forwardable

      def_delegators :@instance, :chdir, :mkdir, :rmdir

      # Creates and returns a new `FTP` session instance
      # @param [Hash] settings the additional `FTP` connection settings
      # @option settings [Integer] :port the port to use
      def initialize(settings = {})
        super
        @port = settings.delete(:port).presence || Net::FTP::FTP_PORT
        @ftp = Net::FTP.new
      end

      # Opens a new FTP connection
      def open
        @ftp.binary = true
        @ftp.passive = true
        @ftp.connect(@uri.host, @port)
        @ftp.login(@login, @password)
      end

      # Closes FTP connection
      def close
        @ftp.close
      end

      # Changes the current (remote) working directory
      # @param [String] path the relative (remote) path
      def chdir(path)
        @ftp.chdir path
      end

      # Creates a remote directory
      # @param [String] dirname the name of new directory
      #   relative to the current (remote) working directory
      def mkdir(dirname)
        @ftp.mkdir dirname
      end

      # Removes the remote directory
      # @param [String] dirname the name of directory to be removed
      def rmdir(dirname)
        @ftp.rmdir dirname
      end

      # Renames (moves) a file on the server
      # @param [String] from the path to move from
      # @param [String] to the new path to move to
      def move(from, to)
        @ftp.rename(from, to)
      end

      # rubocop:disable Lint/UnusedMethodArgument
      # :reek:UnusedParameters
      # For more info (see Dir#glob), it's almost of the same nature
      def glob(pattern)
        fail NotImplementedError
      end
      # rubocop:enable Lint/UnusedMethodArgument
    end
  end
end
