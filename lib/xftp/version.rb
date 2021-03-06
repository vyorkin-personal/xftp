module XFTP
  # Gem version builder module
  module VERSION
    MAJOR = 0
    MINOR = 5
    PATCH = 0
    SUFFIX = ''

    NUMBER = [MAJOR, MINOR, PATCH].compact.join('.')
    STRING =  "#{NUMBER}#{SUFFIX}"
  end
end
