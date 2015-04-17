RSpec.shared_context 'valid connection settings' do
  def valid_connection_settings_for(scheme, options = {})
    {
      url: "#{scheme}://example.com",
      credentials: {
        login: 'login',
        password: 'password'
      }
    }.merge(options)
  end
end
