require 'fake_ftp'

RSpec.describe XFTP::Session::FTP do
  let(:server) { FakeFtp::Server.new(21_212, 21_213) }

  before(:each) { server.start }
  after(:each) { server.stop }

  let(:session) { described_class.new(uri, settings) }
  subject { -> { session.start } }

  context 'given valid FTP URI' do
    let(:uri) { URI('ftp://127.0.0.1:21212') }
    let(:settings) { {} }

    it { is_expected.not_to raise_error }
  end
end
