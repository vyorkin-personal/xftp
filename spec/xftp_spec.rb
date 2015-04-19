# require_relative 'support/shared/examples/xftp_facade'

RSpec.describe XFTP do
  it 'has a version number' do
    expect(XFTP::VERSION::STRING).not_to be nil
  end

  describe '.start' do
    it 'zbs' do
      settings = {
        url: 'ftp://example.com',
        credentials: {
          login: 'login',
          password: 'password'
        }
      }

      session = instance_double('XFTP::Session::Base')
      expect(session).to receive(:start)
      callback = ->(s) { puts s }
      XFTP.start(settings, &callback)
    end

    # context 'given valid ftp connection settings' do
    #   it_behaves_like 'xftp facade', :ftp, port: 21_213
    # end

    # context 'given valid sftp connection settings' do
    #   it_behaves_like 'xftp facade', :ftps
    # end
  end
end
