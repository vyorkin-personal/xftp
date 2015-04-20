RSpec.describe XFTP do
  it 'has a version number' do
    expect(XFTP::VERSION::STRING).not_to be nil
  end

  describe '.start' do
    subject { ->(callback) { XFTP.start(url, {}, &callback) } }
    let(:scheme_adapters) { { ftp: double('ftp'), ftps: double('sftp') } }
    let(:sessions) { { ftp: double('ftp'), ftps: double('sftp') } }

    before(:each) do
      stub_const('XFTP::SCHEME_ADAPTERS', scheme_adapters)
      scheme_adapters.each do |scheme, klass|
        session = sessions[scheme]
        allow(klass).to receive(:new).and_return(session)
        allow(session).to receive(:start).and_yield(session)
      end
    end

    context 'given FTP URI and connection settings without credentials' do
      let(:url) { 'ftp://example.com' }
      it { is_expected.to yield_with_args(sessions[:ftp]) }
    end
  end
end
