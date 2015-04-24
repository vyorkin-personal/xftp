lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xftp/version'

Gem::Specification.new do |spec|
  spec.name = 'xftp'
  spec.version = XFTP::VERSION::STRING
  spec.platform = Gem::Platform::RUBY
  spec.authors = ['Vasiliy Yorkin']
  spec.email = ['vasiliy.yorkin@gmail.com']

  spec.summary = "xftp-#{XFTP::VERSION::STRING}"
  spec.description = 'Unified interface for ftp/sftp protocols, specific protocol is selected by uri scheme'
  spec.homepage = 'https://github.com/vyorkin/xftp'

  spec.files = `git ls-files -- lib/*`.split("\n")
  spec.files += %w(README.md LICENSE.txt)
  spec.bindir = 'exe'
  spec.executables = `git ls-files -- exe/*`.split("\n").map { |file| File.basename(file) }

  spec.test_files = []
  spec.require_path = 'lib'
  spec.license = 'MIT'

  spec.add_development_dependency 'bundler', '~> 1.8'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'yard', '~> 0.8', '>= 0.8.7'
  spec.add_development_dependency 'yard-rspec', '~> 0.1'
  spec.add_development_dependency 'rspec', '~> 3.2', '>= 3.2.0'
  spec.add_development_dependency 'simplecov', '~> 0.9', '>= 0.9.2'

  spec.add_runtime_dependency 'i18n', '~> 0.6', '>= 0.6.0'
  spec.add_runtime_dependency 'net-sftp', '~> 2.1', '>= 2.1.2'
  spec.add_runtime_dependency 'activesupport', '~> 3.2', '>= 3.2.21'
end
