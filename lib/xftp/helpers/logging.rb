require 'colorize'

module XFTP
  module Helpers
    # Provides logging helper methods
    # @api private
    module Logging
      # Appends message to log
      # @param [String] message the log message
      # @param [Symbol] severity the message severity
      # @param [Symbol] color
      # :reek:UtilityFunction:
      def log(message, severity: :info, color: :white)
        text = message.colorize(color)
        XFTP.config.logger.public_send(severity, text)
      end
    end
  end
end
