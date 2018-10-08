require 'bcrypt'

class Api::V1::UsersController < ApiController
  include BCrypt

  def index
  end
  def new
  end
  def create
    # pass the params to the register function of the User
    @response = User.register(
      params[:user_name],
      params[:email],
      params[:password],
      params[:password_confirmation],
    )

    # response can either be a returned [@user,@auth_token] or @errors

    if @response.count == 2
      render json: { 'user': @response[0].slice(:user_name,:email), 'token': @response[1].slice(:expiry,:auth_hash) }
    else
      render json: @response, except: [:id, :created_at, :updated_at]
    end

  end
  def login

  end
end
