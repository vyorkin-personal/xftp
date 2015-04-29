require 'net/ssh'
require 'net/sftp'

require 'xftp/session/base'

module XFTP
  module Session
    # SFTP session adapter
    # @api private
    class SFTP < Base
      # Helper class for progress monitoring
      class ProgressHandler
        include Helpers::Logging

        def on_open(_downloader, file)
          log "starting download: #{file.remote} -> #{file.local} (#{file.size} bytes)"
        end

        def on_get(_downloader, file, offset, data)
          log "writing #{data.length} bytes to #{file.local} starting at #{offset}"
        end

        def on_close(_downloader, file)
          log "finished with #{file.remote}"
        end

        def on_mkdir(_downloader, path)
          log "creating directory #{path}"
        end

        def on_finish(_downloader)
          log 'done'
        end
      end

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
        @settings[:password] = @credentials[:password]
        @ssh_options = XFTP.config.ssh.deep_merge(@settings)
      end

      # Changes the current (remote) working directory
      # @param [String] path the relative (remote) path
      def chdir(path)
        ensure_relative_path! :chdir, path
        @path += path
      end

      # Creates a remote directory
      # @param [String] dirname the name of new directory
      #   relative to the current (remote) working directory
      # @param [Hash] attrs the attributes of new directory
      #   supported by the the version of SFTP protocol in use
      def mkdir(dirname, attrs = {})
        ensure_relative_path! :mkdir, path
        @sftp.mkdir!(remote_path(dirname), attrs)
      end

      # Removes the remote directory
      # @param [String] dirname the name of directory to be removed
      def rmdir(dirname)
        ensure_relative_path! :rmdir, path
        @sftp.rmdir! remote_path(dirname)
      end

      # @return [Boolean] `true` if the file exists
      # in a current working directory on the remote host
      def exists?(filename)
        entries.include? filename
      end

      # @return [Boolean] `true` if the argument refers to
      # a directory on the remote host
      def directory?(path)
        ensure_relative_path! :directory?, path
        @sftp.file.directory? remote_path(path)
      end

      # @return [Boolean] `true` if the argument refers to
      # a file on the remote host
      def file?(path)
        !directory?(path)
      end

      # Renames (moves) a file on the server
      # @param [String] from the path to move from
      # @param [String] to the path to move to
      def move(from, to:, flags: RENAME_OPERATION_FLAGS)
        log "moving from #{from} to #{to}..."
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

      # Calls the block once for each entry in the current directory
      # on the remote server and (asynchronously) yields a filename and `StringIO` object to the block
      def each_io
        each_file do |filename|
          io = get filename
          yield filename, io
        end
      end

      # Downloads file into IO object
      # @return [StringIO] the remote file data
      def get(filename)
        @sftp.download!(remote_path(filename), nil, progress: ProgressHandler)
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
        log "downloading file from #{from} to #{to}..."
        remote = remote_path(from)
        local = (Pathname.pwd + to).to_s
        @sftp.download!(remote, local, options)
      end

      # @return [Array<String>] an array of filenames in the remote directory
      def files
        entries.reject { |filename| directory? filename }
      end

      # @return [Array<String>] an array of entries (including directories) in the remote directory
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
        log 'closing connection'
        @ssh.close
      end

      private

      def connect
        log 'opening connection...'
        @ssh = Net::SSH.start(@uri.host, @credentials[:login], @ssh_options)
        @sftp = Net::SFTP::Session.new @ssh
        @sftp.connect!
        log 'connected'
      end

      # @return [String] a path name relative to the current working directory
      def remote_path(relative)
        (@path + relative).to_s
      end
    end
  end
end
