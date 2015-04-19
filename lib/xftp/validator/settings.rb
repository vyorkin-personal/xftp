module XFTP
  module Validator
    # Connection settings validator
    # @api private
    class Settings
      include Errors

      # Validates the given connection settings
      # @param [URI] uri the remote uri
      # @param [Hash] settings the session connection settings
      # @raise [XFTP::MissingArgument] if some of the required settings are missing
      def call!(uri, settings)
        validate_credentials!(settings[:credentials]) if uri.scheme == 'ftps'
      end

      private

      def validate_credentials!(credentials)
        missing_setting!(:credentials) unless credentials.present?
        missing_setting!(:login) unless credentials[:login].present?
        missing_setting!(:password) unless credentials[:password].present?
      end
    end
  end
end
