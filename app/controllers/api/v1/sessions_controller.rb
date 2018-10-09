class Api::V1::SessionsController < ApiController
  def new
  end
  def create
    errors = Sessions::Authenticator.validate(params)
    if errors.empty?
      user_store = Sessions::Authenticator.login(params)
      render json: user_store
    else
      render json: errors
    end
  end
end
