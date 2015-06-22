RSpec.describe XFTP::Client do
  let(:scheme_adapters) { { ftp: double('ftp'), sftp: double('sftp') } }
  let(:client) { described_class.new(scheme_adapters) }
  let(:url) { "#{scheme}://example.com" }

  subject { ->(callback) { client.call(url, {}, &callback) } }

  before(:each) do
    allow(scheme_adapters[scheme]).to receive(:new).and_return(scheme_adapters[scheme])
    allow(client).to receive(:call).and_yield(scheme_adapters[scheme])
  end

  describe '.call' do
    context 'given uri with ftp scheme' do
      let(:scheme) { :ftp }
      it { is_expected.to yield_with_args(scheme_adapters[scheme]) }
    end

    context 'given uri with sftp scheme' do
      let(:scheme) { :sftp }
      it { is_expected.to yield_with_args(scheme_adapters[scheme]) }
    end
  end
end
