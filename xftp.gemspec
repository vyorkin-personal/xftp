lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xftp/version'

TEST_FILES = %r{^(test|spec|features)/}

Gem::Specification.new do |spec|
  spec.name          = 'xftp'
  spec.version       = XFTP::VERSION::STRING
  spec.authors       = ['Vasiliy Yorkin']
  spec.email         = ['vasiliy.yorkin@gmail.com']

  spec.summary       = 'Unified interface for ftp/sftp'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/vyorkin/xftp'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match TEST_FILES }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(TEST_FILES)
  spec.require_paths = ['lib']
  spec.licenses      = ['MIT']

  spec.add_development_dependency 'bundler', '~> 1.8'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'yard', '~> 0.8.7'
  spec.add_development_dependency 'yard-rspec', '~> 0.1'
  spec.add_development_dependency 'rspec', '~> 3.2.0'
  spec.add_development_dependency 'simplecov', '~> 0.9.2'
  spec.add_development_dependency 'fake_ftp', '~> 0.1.1'

  spec.add_runtime_dependency 'i18n', '~> 0.6.0'
  spec.add_runtime_dependency 'net-sftp', '~> 2.1.2'
  spec.add_runtime_dependency 'activesupport', '~> 3.2.21'
end
