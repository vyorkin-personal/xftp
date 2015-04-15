RSpec.shared_context 'valid connection settings' do
  def valid_connection_settings_for(scheme)
    {
      url: "#{scheme}://example.com",
      credentials: {
        login: 'login',
        password: 'password'
      }
    }
  end
end
