require 'active_support/core_ext/hash/deep_merge'
require 'net/ftp'

require 'xftp/session/base'
require 'xftp/operations/ftp/glob'

module XFTP
  module Session
    # FTP session adapter
    # @api private
    class FTP < Base
      # Creates an FTP session adapter instance
      # @param [URI] uri the remote uri
      # @param [Hash] settings the adapter connection settings
      def initialize(uri, settings = {})
        super

        @ftp = Net::FTP.new
        @port = settings.delete(:port) || uri.port || Net::FTP::FTP_PORT
        @credentials[:login] ||= 'anonymous'

        options = XFTP.config.ftp.deep_merge(@settings)
        options.each { |key, val| @ftp.public_send("#{key}=", val) }
      end

      # Changes the current (remote) working directory
      # @param [String] path the relative (remote) path
      def chdir(path)
        ensure_relative_path! :chdir, path
        @ftp.chdir path
      end

      # Creates a remote directory
      # @param [String] dirname the name of new directory
      #   relative to the current (remote) working directory
      def mkdir(dirname)
        ensure_relative_path! :mkdir, dirname
        @ftp.mkdir dirname
      end

      # Removes the remote directory
      # @param [String] dirname the name of directory to be removed
      def rmdir(dirname)
        ensure_relative_path! :rmdir, dirname
        @ftp.rmdir dirname
      end

      # @return [Boolean] `true` if the argument refers to a directory on the remote host
      def exists?(dirname)
        entries.include? dirname
      end

      # HACK: It looks ridiculous, but its the only way to find out
      # if the given remote path is a file or directory

      # @return [Boolean] `true` if the argument refers to
      # a directory on the remote host
      def directory?(path)
        ensure_relative_path! :directory?, path
        chdir path
        chdir '..'
        true
      rescue
        false
      end

      # @return [Boolean] `true` if the argument refers to
      # a file on the remote host
      def file?(path)
        !directory?(path)
      end

      # Renames (moves) a file on the server
      # @param [String] from the path to move from
      # @param [String] to the new path to move to
      def move(from, to:)
        log "moving from #{from} to #{to}..."
        @ftp.rename(from, to)
      end

      # Calls the block once for each entry in the current directory
      # on the remote server and yields a filename to the block
      def each_file
        files.each { |filename| yield filename }
      end

      # Calls the block once for each entry in the current directory
      # on the remote server and yields a filename and `StringIO` object to the block
      def each_io
        each_file do |filename|
          io = get filename
          yield filename, io
        end
      end

      # Downloads file into IO object
      # @return [StringIO] the remote file data
      def get(filename)
        @ftp.getbinaryfile(filename, nil)
      end

      # @see XFTP::Operations::FTP::Glob
      def glob(pattern, &callback)
        Operations::FTP::Glob.new(@ftp).call(pattern, &callback)
      end

      # Initiates a download from remote to local, synchronously
      # @param [String] from the source remote file name
      # @param [String] to the target local file name
      # @param [Integer] block_size the size of file chunk
      # @see Net::FTP#get
      def download(from, to: File.basename(from), block_size: Net::FTP::DEFAULT_BLOCKSIZE)
        log "downloading file from #{from} to #{to}..."
        @ftp.get(from, to, block_size)
      end

      # @return [Array<String>] an array of filenames in the remote directory
      def files
        entries.select { |entry| file? entry }
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
        log 'opening connection...'
        @ftp.connect(@uri.host, @port)
        log 'connected'
        @ftp.login(@credentials[:login], @credentials[:password])
        log 'logging in...'
      end

      # Closes FTP connection
      def close
        log 'closing connection'
        @ftp.close
      end
    end
  end
end
