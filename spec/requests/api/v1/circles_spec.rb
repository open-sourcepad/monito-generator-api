RSpec.describe 'Circles API' do
  require 'sidekiq/testing'
  Sidekiq::Testing.fake!
  before(:all) do
    @params = {email: 'sample@email.com',
               password: '123456'}
    AuthHelpers.create_user(@params[:email], @params[:password])
    post '/api/sessions', params: @params
    resp = RequestHelpers.json response.body
    @creds = { user_name: resp['user_name'], auth_hash: resp['auth_hash'] }
    @circle_params = { circle_name: 'Sample Circle', 
                       budget: '1,500',
                       exchange_date: '2019-10-10',
                       user_name: @creds[:user_name],
                       auth_hash: @creds[:auth_hash],
                       code_name: 'code_name',
                       wish_list: [{wish: 'car'}],
                       user_events: [{userEvent: 'Something Big'}]}
  end

  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end

  context 'user logged in' do
    it 'can create circle' do
      post '/api/circles', params: @circle_params
      resp = RequestHelpers.json response.body
      expect(resp).to include('success')
    end
    it 'can show existing circle' do
      post '/api/circles', params: @circle_params
      exist_circle_id = Circle.all.first.id
      get  "/api/circles/#{exist_circle_id}"
      resp = RequestHelpers.json response.body

      expect(resp).to include('circle_found', 'accepted_emails')
    end
    it 'can invite other users' do
      post '/api/circles', params: @circle_params
      exist_circle_id = Circle.all.first.id
      @circle_params['id'] = exist_circle_id
      post "/api/circles/#{exist_circle_id}/send_emails",
           params:{current_circle: @circle_params, 
                   invitations: { users: [{email: "unique_email@email.com"}]}}
      resp = RequestHelpers.json response.body
      expect(resp['existing_emails']).to eq([])
    end
    it 'cannot invite in-circle users (and himself)' do
      post '/api/circles', params: @circle_params
      exist_circle_id = Circle.all.first.id
      @circle_params['id'] = exist_circle_id
      post "/api/circles/#{exist_circle_id}/send_emails",
           params:{current_circle: @circle_params, 
                   invitations: { users: [{email: @params[:email]}]}}
      resp = RequestHelpers.json response.body
      expect(resp['existing_emails']).to include(@params[:email])
    end
  end
  context 'user logged out' do
    it 'cannot create circle' do
      @circle_params['user_name'] = nil
      @circle_params['auth_hash'] = nil
      post '/api/circles', params: @circle_params
      resp = RequestHelpers.json response.body
      expect(resp).to include('error')
    end
  end
end
