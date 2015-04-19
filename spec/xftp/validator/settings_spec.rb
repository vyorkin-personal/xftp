RSpec.describe XFTP::Validator::Settings do
  subject { -> { XFTP::Validator::Settings.new.call!(settings) } }

  context 'given valid connection settings with SFTP url scheme' do
    let(:settings) { { url: 'ftps://example.com', credentials: { login: 'login', password: 'password' } } }
    it { is_expected.not_to raise_error }
  end

  context 'given connection settings without url' do
    let(:settings) { { credentials: { login: 'login', password: 'password' } } }
    it { is_expected.to raise_error I18n.t('errors.missing_setting', key: :url) }
  end

  context 'given connection settings without credentials' do
    let(:settings) { { url: 'ftp://example.com' } }
    it { is_expected.to raise_error I18n.t('errors.missing_setting', key: :credentials) }
  end

  context 'given connection settings without login' do
    let(:settings) { { url: 'ftp://example.com', credentials: { password: 'password' } } }
    it { is_expected.to raise_error I18n.t('errors.missing_setting', key: :login) }
  end

  context 'given connection settings without password' do
    let(:settings) { { url: 'ftp://example.com', credentials: { login: 'login' } } }
    it { is_expected.to raise_error I18n.t('errors.missing_setting', key: :password) }
  end
end
