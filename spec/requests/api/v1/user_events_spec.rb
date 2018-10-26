RSpec.describe 'UserEvents API' do
  before(:all) do
    @params = { email: 'sample@email.com',
                password: '123456'}
    AuthHelpers.create_user(@params[:email], @params[:password])
    post '/api/sessions/', params: @params
    resp = RequestHelpers.json response.body
    @circle_params = { circle_name: 'Sample Circle', 
                       budget: '1,500',
                       exchange_date: '3000-10-10',
                       user_name: resp['user_name'],
                       auth_hash: resp['auth_hash'],
                       code_name: 'code_name',
                       wish_list: [{wish: 'car'}],
                       user_events: [{userEvent: 'Something Big', 
                                      exchange_date: '3000-8-10'},
                                     {userEvent: 'Something Big', 
                                      exchange_date: '3000-9-10'}]}
  end

  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end

  it 'returns all user_events for user' do
    post '/api/circles', params: @circle_params
    exist_user_name = User.find_by(email: @params[:email]).user_name
    get '/api/user_events', params: {current_user: exist_user_name}
    resp = RequestHelpers.json response.body

    expect(resp['user_events'].count).to eq 3
  end
end
