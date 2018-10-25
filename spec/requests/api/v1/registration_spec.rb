RSpec.describe 'User Registration' do
  before(:all) do
    @params = {user_name: 'sample_user',
              email: 'sampple@email.com',
              password: '123456',
              password_confirmation: '123456'}
  end
  context 'it has valid form data' do
    it 'creates a new user' do
      post '/api/users', params: @params
      expect(response.body).to include('user_name')
    end
  end

  context 'it has invalid form data' do
    context 'has a user_name that is already taken' do
      it "returns a 'user_name_already_taken' error " do
        user_fact = FactoryBot.create(:user, user_name: @params[:user_name])
        post '/api/users', params: @params

        expect(response.body).to include('user_error')
      end
    end

    context 'has an email that is already taken' do
      it "returns an 'email_already_taken' error" do
        user_fact = FactoryBot.create(:user, email: @params[:email])
        post '/api/users', params: @params

        expect(response.body).to include('email_error')
      end
    end

    context 'has passwords that dont match' do
      it "returns a 'password_does_not_match' error" do
        @params[:password] = '123456'
        @params[:password_confirmation] = '654321'

        post '/api/users', params: @params

        expect(response.body).to include('pass_error')
      end
    end
  end

end
