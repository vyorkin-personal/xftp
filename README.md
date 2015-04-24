[![Build Status](https://travis-ci.org/vyorkin/xftp.svg)](https://travis-ci.org/vyorkin/xftp)

# xftp

Unified interface for ftp/sftp.
Protocol is selected by url scheme.

## Installation

```ruby
gem 'xftp'
```

or

```
$ gem install xftp
```

## Usage

```ruby
XFTP.start('ftps://hostname', credentials: { login: 'login', password: 'pass' }) do |x|
    x.chdir 'remote-src-path'
    x.mkdir 'new-remote-dir'
    x.rmdir 'dir-to-remove'

    x.each_file do |file|
        x.download file
        x.move file, to: File.join('remote-archive-path', file)
    end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/xftp/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
