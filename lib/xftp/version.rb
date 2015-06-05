module XFTP
  # Gem version builder module
  module VERSION
    MAJOR = 0
    MINOR = 4
    PATCH = 4
    SUFFIX = ''

    NUMBER = [MAJOR, MINOR, PATCH].compact.join('.')
    STRING =  "#{NUMBER}#{SUFFIX}"
  end
end
