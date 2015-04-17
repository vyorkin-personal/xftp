module XFTP
  module Validator
    # Connection settings validator
    # @api private
    class ConnectionSettings
      include Errors

      # Validates the given connection settings
      # @param [Hash] settings the session connection settings
      # @see XFTP::Session::Base
      # @raise [XFTP::MissingArgument] if some of the required settings are missing
      def validate!(settings)
        missing_setting!(:url) unless settings[:url].present?

        credentials = settings[:credentials]
        if credentials.present?
          validate_credentials!(credentials)
        else
          missing_setting! :credentials
        end
      end

      private

      def validate_credentials!(credentials)
        %i(login password).each { |key| missing_setting!(key) unless credentials[key].present? }
      end
    end
  end
end
