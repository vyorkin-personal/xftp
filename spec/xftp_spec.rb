require_relative 'support/shared/examples/xftp_facade'

RSpec.describe XFTP do
  it 'has a version number' do
    expect(XFTP::VERSION::STRING).not_to be nil
  end

  describe '.start' do
    context 'given valid ftp connection settings' do
      it_behaves_like 'xftp facade', :ftp, port: 21_213
    end

    context 'given valid sftp connection settings' do
      it_behaves_like 'xftp facade', :ftps
    end
  end
end
