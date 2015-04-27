require 'colorize'

module XFTP
  module Helper
    # Provides logging helper methods
    # @api private
    module Logging
      private

      %i(verbose colorize).each do |name|
        define_method("#{name}_logging?".to_sym) do
          XFTP.config.logging[name]
        end
      end

      def log(message, severity: :info, color: :white)
        text = message.colorize(color) if colorize_logging?
        XFTP.config.logging[:logger].public_send(severity, text)
      end
    end
  end
end
