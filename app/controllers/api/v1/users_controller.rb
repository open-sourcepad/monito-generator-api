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

    # response can either be a returned @user or @errors
    debugger
    render json: @response, except: [:id, :password_hash, :created_at, :updated_at]
  end
end
