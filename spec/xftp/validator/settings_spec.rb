RSpec.describe XFTP::Validator::Settings do
  subject { -> { described_class.new.call!(uri, settings) } }

  context 'given FTP URI' do
    let(:uri) { URI('ftp://example.com') }

    context 'given connection settings with credentials' do
      let(:settings) { { credentials: { login: 'login', password: 'password' } } }
      it { is_expected.not_to raise_error }
    end

    context 'given connection settings without credentials' do
      let(:settings) { {} }
      it { is_expected.not_to raise_error }
    end
  end

  context 'given SFTP URI' do
    let(:uri) { URI('ftps://example.com') }

    context 'given connection settings with credentials' do
      let(:settings) { { credentials: { login: 'login', password: 'password' } } }
      it { is_expected.not_to raise_error }
    end

    context 'given connection settings without credentials' do
      let(:settings) { {} }
      it { is_expected.to raise_error I18n.t('errors.missing_setting', key: :credentials) }
    end

    context 'given connection settings without login' do
      let(:settings) { { credentials: { password: 'password' } } }
      it { is_expected.to raise_error I18n.t('errors.missing_setting', key: :login) }
    end

    context 'given connection settings without password' do
      let(:settings) { { url: 'ftp://example.com', credentials: { login: 'login' } } }
      it { is_expected.to raise_error I18n.t('errors.missing_setting', key: :password) }
    end
  end
end
