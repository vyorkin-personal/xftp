require 'xftp/session/base'
require 'net/ssh'
require 'net/sftp'

module XFTP
  module Session
    # SFTP session adapter
    # @api private
    class SFTP < Base
      # Default flags for rename operation
      RENAME_OPERATION_FLAGS = 0x0004
      # Default flags for glob operation
      GLOB_OPERATION_FLAGS = File::FNM_EXTGLOB

      # Creates and returns a new `SFTP` session instance
      # @param [Hash] settings the additional `SFTP` connection settings
      # @option settings [Hash] :ssh the ssh connection options
      def initialize(settings = {})
        super
        user_options = settings.delete(:ssh) || {}
        options = user_options.merge(password: @password)
        @ssh = Net::SSH.start(@uri.host, @login, options)
        @sftp = Net::SFTP::Session.new @ssh
        @path = Pathname '.'
      end

      # Opens a new SFTP connection
      def open
        @sftp.connect!
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
        @sftp.session.close
      end

      # Changes the current (remote) working directory
      # @param [String] path the relative (remote) path
      def chdir(path)
        @path /= path
      end

      # Creates a remote directory
      # @param [String] dirname the name of new directory
      #   relative to the current (remote) working directory
      # @param [Hash] attrs the attributes of new directory
      #   supported by the the version of SFTP protocol in use
      def mkdir(dirname, attrs = {})
        @sftp.mkdir! pathname(dirname), attrs
      end

      # Removes the remote directory
      # @param [String] dirname the name of directory to be removed
      def rmdir(dirname)
        @sftp.rmdir! pathname(dirname)
      end

      # Renames (moves) a file on the server
      # @param [String] from the path to move from
      # @param [String] to the path to move to
      def move(from, to, flags = RENAME_OPERATION_FLAGS)
        @sftp.rename(from, to, flags)
      end

      # For more info (see Dir#glob), it's almost of the same nature
      # @param [String] pattern the search pattern relative
      #   the the current working directory
      # @param [Integer] (see File.fnmatch) for the meaning of the flags parameter.
      #   Default value is `File::FNM_EXTGLOB`
      def glob(pattern, flags = GLOB_OPERATION_FLAGS)
        @sftp.dir.glob(@path.to_s, pattern, flags)
      end

      private

      # @return [String] a path name relative to the current working directory
      def pathname(relative)
        (@path / relative).to_s
      end
    end
  end
end
