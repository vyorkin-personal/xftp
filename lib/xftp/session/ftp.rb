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

      # @return [Boolean] `true` if the argument refers to a directory on the remote host
      def exists?(dirname)
        entries.include? dirname
      end

      # Renames (moves) a file on the server
      # @param [String] from the path to move from
      # @param [String] to the new path to move to
      def move(from, to:)
        @ftp.rename(from, to)
      end

      # Calls the block once for each entry in the current directory
      # on the remote server and yields a filename to the block
      def each_file
        files.each { |filename| yield filename }
      end

      # @see XFTP::Operations::FTP::Glob
      def glob(pattern, &callback)
        Operations::Glob.new(@ftp).call(pattern, &callback)
      end

      # Initiates a download from remote to local, synchronously
      # @param [String] from the source remote file name
      # @param [String] to the target local file name
      # @param [Integer] block_size the size of file chunk
      # @see Net::FTP#get
      def download(from, to: File.basename(from), block_size: Net::FTP::DEFAULT_BLOCKSIZE)
        @ftp.get(from, to, block_size)
      end

      # @return [Array<String>] an array of filenames in the remote directory
      def files
        # FIXME: This won't work in case of file name without extension
        entries '*.*'
      end

      # @param [String] pattern the wildcard search pattern
      # @return [Array<String>] an array of entries (including directories)
      #   in the remote directory
      def entries(pattern = nil)
        @ftp.nlst pattern
      end

      protected

      # Opens a new FTP connection and authenticates on the remote server
      def open
        @ftp.connect(@uri.host, @port)
        @ftp.login(@credentials[:login], @credentials[:password])
      end
    end
  end
end
