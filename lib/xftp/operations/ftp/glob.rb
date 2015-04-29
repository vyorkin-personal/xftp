module XFTP
  module Operations
    module FTP
      # Provides a naive glob operation implementation, using (see FTP#nlst) method
      # @api private
      # @see Net::FTP#nslt
      # @note It isn't tested on Windows OS and chances are that it won't work,
      #   that's why it is implemented as a separate "command"
      class Glob
        NO_SUCH_FILE_OR_DIRECTORY_CODE = 450

        def initialize(ftp)
          @ftp = ftp
        end

        # Expands pattern and returns the results
        # as matches or as arguments given to the block
        # @param [String] pattern the search pattern
        # @param [Proc] callback
        def call(pattern, &callback)
          @ftp.nlst(pattern).each { |filename| callback.call(filename) }
        rescue Net::FTPTempError => err
          code = err.to_s[0, 3].try(:to_i)
          raise err unless code == NO_SUCH_FILE_OR_DIRECTORY_CODE
        end
      end
    end
  end
end
