require_relative 'support/shared/contexts/connection_settings'

RSpec.describe XFTP do
  it 'has a version number' do
    expect(XFTP::VERSION::STRING).not_to be nil
  end

  describe '.start' do
    include_context 'valid connection settings'
    subject { ->(b) { XFTP.start(settings, &b) } }

    context 'given valid ftp connection settings' do
      let(:settings) { valid_connection_settings_for(:ftp) }
      it { is_expected.to yield_with_args(XFTP::Session::FTP) }
    end

    context 'given valid sftp connection settings' do
      let(:settings) { valid_connection_settings_for(:ftps) }
      it { is_expected.to yield_with_args(XFTP::Session::SFTP) }
    end
  end
end
