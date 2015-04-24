require 'net/ssh'
require 'net/sftp'

require 'xftp/session/base'

module XFTP
  module Session
    # SFTP session adapter
    # @api private
    class SFTP < Base
      # Default flags for rename operation
      RENAME_OPERATION_FLAGS = 0x0004
      # Default flags for glob operation
      GLOB_OPERATION_FLAGS = File::FNM_EXTGLOB

      # Creates an SFTP session adapter instance
      # @param [URI] uri the remote uri
      # @param [Hash] settings the adapter connection settings
      def initialize(uri, settings = {})
        super
        @path = Pathname '.'
        @settings.merge!(password: @credentials[:password])
        @ssh_options = XFTP.config.ssh.deep_merge(@settings)
      end

      # Changes the current (remote) working directory
      # @param [String] path the relative (remote) path
      def chdir(path)
        @path += path
      end

      # Creates a remote directory
      # @param [String] dirname the name of new directory
      #   relative to the current (remote) working directory
      # @param [Hash] attrs the attributes of new directory
      #   supported by the the version of SFTP protocol in use
      def mkdir(dirname, attrs = {})
        @sftp.mkdir!(remote_path(dirname), attrs)
      end

      # @return [Boolean] `true` if the file exists
      # in a current working directory on the remote host
      def exists?(filename)
        entries.include? filename
      end

      # @return [Boolean] `true` if the argument refers to a directory on the remote host
      def directory?(dirname)
        @sftp.file.directory? remote_path(dirname)
      end

      # Removes the remote directory
      # @param [String] dirname the name of directory to be removed
      def rmdir(dirname)
        @sftp.rmdir! remote_path(dirname)
      end

      # Renames (moves) a file on the server
      # @param [String] from the path to move from
      # @param [String] to the path to move to
      def move(from, to:, flags: RENAME_OPERATION_FLAGS)
        @sftp.rename!(remote_path(from), remote_path(to), flags)
      end

      # Calls the block once for each entry in the current directory
      # on the remote server and (asynchronously) yields a filename to the block
      def each_file
        @sftp.dir.foreach(@path.to_s) do |entry|
          filename = entry.name
          yield filename unless directory? filename
        end
      end

      # For more info (see Dir#glob), it's almost of the same nature
      # @param [String] pattern the search pattern relative
      #   the the current working directory
      # @param [Integer] (see File.fnmatch) for the meaning of the flags parameter.
      #   Default value is `File::FNM_EXTGLOB`
      def glob(pattern, flags: GLOB_OPERATION_FLAGS)
        @sftp.dir.glob(@path.to_s, pattern, flags) { |entry| yield entry.name }
      end

      # Initiates a download from remote to local, synchronously
      # @param [String] from the source remote file name
      # @param [String] to the target local file name
      # @param [Hash] options the download operation options
      # @see Net::SFTP::Operations::Download
      def download(from, to: File.basename(from), **options)
        remote = remote_path(from)
        local = (Pathname.pwd + to).to_s
        @sftp.download!(remote, local, options)
      end

      # @return [Array<String>] an array of filenames in the remote directory
      def files
        entries.reject { |filename| directory? filename }
      end

      # @return [Array<String>] an array of entries (including directories)
      #   in the remote directory
      def entries
        @sftp.dir.entries(@path.to_s).map(&:name)
      end

      protected

      # Opens a new SFTP connection
      def open
        connect
      rescue Object => anything
        begin
          @ssh.shutdown!
        rescue ::Exception # rubocop:disable Lint/HandleExceptions, Lint/RescueException
          # swallow exceptions that occur while trying to shutdown
        end

        raise anything
      end

      # Closes SFTP (SSH) connection
      def close
        @ssh.close
      end

      private

      def connect
        @ssh = Net::SSH.start(@uri.host, @credentials[:login], @ssh_options)
        @sftp = Net::SFTP::Session.new @ssh
        @sftp.connect!
      end

      # @return [String] a path name relative to the current working directory
      def remote_path(relative)
        (@path + relative).to_s
      end
    end
  end
end
