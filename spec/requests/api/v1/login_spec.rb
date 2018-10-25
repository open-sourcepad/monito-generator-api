include BCrypt

RSpec.describe 'User Login' do
  before(:all) do
    @params = {email: 'sample@email.com',
               password: '123456'}
    user_fact = FactoryBot.create(:user, password_hash: Password.create(@params[:password]))
  end

  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end

  context 'valid email/password combo' do
    it 'login and return user_name' do
      post '/api/sessions', params: @params

      expect(response.body).to include('user_name', 'auth_hash')
    end
  end
  context 'invalid email/password combo' do
    it 'returns invalid email/password error' do
      @params['password'] = 'wrong_password'
      post '/api/sessions', params: @params

      expect(response.body).to include('user_error')
    end
  end
end
