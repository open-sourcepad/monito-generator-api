class Api::V1::SessionsController < ApiController
  def create
    errors = Sessions::Authenticator.validate(params)
    if errors.empty?
      user_store = Sessions::Authenticator.login(params)
      render json: user_store
    else
      render json: errors
    end
  end
  def validate
    # params['user_name']
    # params['auth_hash']
    render json: {"valid_login": true}
    #auth_token = AuthToken.find_by(auth_hash: params['auth_hash'])
    #if auth_token and (auth_token.expiry > DateTime.now)
    #  render json: {"valid_login": true}
    #else
    #  render json: {"valid_loginj": false}
    #end
  end
end
