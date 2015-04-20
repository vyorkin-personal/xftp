require 'xftp/dsl/block_evaluator'

module XFTP
  module Session
    # @abstract Base class for xftp session adapters
    # @api private
    class Base
      include DSL::BlockEvaluator

      attr_reader :uri, :credentials, :settings

      # Creates a session adapter instance
      # @param [URI] uri the remote uri
      # @param [Hash] settings the adapter connection settings
      def initialize(uri, settings = {})
        @uri = uri
        @credentials = settings.delete(:credentials) || {}
        @settings = settings
      end

      # Opens a new connection, evaluates the given block and closes the connection
      # @param [Proc] callback the callback to operate on a connection session
      def start(&callback)
        open
        evaluate(&callback)
        close
      end
    end
  end
end
