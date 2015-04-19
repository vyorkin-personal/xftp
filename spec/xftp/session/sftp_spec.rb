RSpec.describe XFTP::Session::SFTP do
  let(:ftp) { double('Net::SFTP') }
  let(:session) { described_class.new }

  before(:each) do
    stub_const('Net::SFTP', ftp)
  end

  describe 'API adaptation' do
    context '#chdir' do
      let(:dirname) { 'confirmation/shipping' }
      subject { -> { session.chdir('dirname') } }
      it { is_expected.to receive(:chdir).with(dirname).exactly(1).times }
    end
  end
end
