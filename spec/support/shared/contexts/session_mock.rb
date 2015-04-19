RSpec.shared_context 'session mock' do
  def mock_session_for(scheme)
    stub_const("XFTP::Session::#{scheme}", session)
  end
end
