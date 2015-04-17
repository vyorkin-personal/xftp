require_relative '../contexts/connection_settings'

RSpec.shared_examples 'xftp facade' do |scheme, options = {}|
  include_context 'valid connection settings'

  subject { ->(callback) { XFTP.start(settings, &callback) } }

  let(:session) { double('session') }
  let(:settings) { valid_connection_settings_for(scheme, options) }

  before(:each) do
    class_name = scheme.to_s.upcase
    stub_const("XFTP::Session::#{class_name}", session)
    allow(session).to receive(:start).and_yield(session)
  end
end
