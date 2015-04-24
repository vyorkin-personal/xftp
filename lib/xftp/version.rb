module XFTP
  # Gem version builder module
  module VERSION
    MAJOR = 0
    MINOR = 2
    PATCH = 0
    SUFFIX = 'alpha'

    NUMBER = [MAJOR, MINOR, PATCH].compact.join('.')
    STRING =  "#{NUMBER}-#{SUFFIX}"
  end
end
