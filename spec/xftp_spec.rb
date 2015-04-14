# 1) it evaluates the given block
# 2) it sets connection options
# 3) raises an error if required options are not supplied
RSpec.describe XFTP do
  it 'has a version number' do
    expect(XFTP::VERSION::STRING).not_to be nil
  end

  describe '.start' do
    subject { -> { described_class.start({}) } }

    context 'when host option is not supplied' do
      it { is_expected.to raise_error I18n.t('errors.missed_config_option', key: :host) }
    end

    context 'given valid options' do
      it { is_expected.not_to raise_error }
    end
  end
end
