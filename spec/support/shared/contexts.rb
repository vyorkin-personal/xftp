RSpec.shared_context 'valid start options with SFTP url scheme' do
  let(:options) { { host: 'ftps://host', credentials: { login: 'login', password: 'password' } } }
end

RSpec.shared_context 'valid start options with FTP url scheme and explicit SFTP protocol' do
end

RSpec.shared_context 'start options without host' do
end

RSpec.shared_context 'start options without credentials' do
end

RSpec.shared_context 'start options without login' do
end

RSpec.shared_context 'start options without password' do
end
