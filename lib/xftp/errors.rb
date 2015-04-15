module XFTP
  # Raises when the given argument does not match required format
  class InvalidArgument < ArgumentError; end
  # Raises when required argument is missing or blank
  class MissingArgument < ArgumentError; end
  # Raise when the given protocol is not supported
  class NotSupportedProtocol < ArgumentError; end

  # Shortcut method to fail
  # with a localized error message
  module Errors
    def missing_setting!(setting)
      fail MissingArgument, I18n.t('errors.missing_setting', key: setting)
    end

    def not_supported_protocol!(protocol)
      fail NotSupportedProtocol, I18n.t('errors.not_supported_protocol', protocol: protocol)
    end
  end
end
