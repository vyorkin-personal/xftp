require_relative '../contexts/connection_settings'

RSpec.shared_examples 'xftp facade' do |scheme, options = {}|
  include_context 'connection settings'

  # subject { ->(callback) { XFTP.start(settings, &callback) } }

  let(:adapter) { {}[scheme] }
  let(:settings) { valid_connection_settings_for(scheme, options) }
  let(:session) { instance_double("XFTP::Session::#{adapter}") }

  # it { is_expected.to yield_with_args(session) }

  it 'huyarit' do
    expect(session).to receive(:start)
    callback = ->(s) { puts s }
    XFTP.start(settings, &callback)
  end
end
