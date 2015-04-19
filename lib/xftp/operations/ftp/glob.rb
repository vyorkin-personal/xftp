module XFTP
  module Operations
    module FTP
      # @api private
      class Glob
        def initialize(ftp)
          @ftp = ftp
        end

        # Expands pattern and returns the results
        # as matches or as arguments given to the block
        # @param [String] pattern the search pattern
        # @param [Proc] callback
        # :reek:UnusedParameters
        # rubocop:disable Lint/UnusedMethodArgument
        def call(pattern, &callback)
          fail NotImplementedError
        end
        # rubocop:enable Lint/UnusedMethodArgument
      end
    end
  end
end
