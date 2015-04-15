source 'https://rubygems.org'

gemspec

group :development, :test do
  gem 'pry-byebug'
end

group :development do
  gem 'reek', require: false
  gem 'brakeman', require: false
  gem 'rubocop', require: false
  gem 'overcommit'
end

group :test do
  gem 'mutant'
  gem 'mutant-rspec'
end
