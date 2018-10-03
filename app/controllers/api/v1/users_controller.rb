require 'bcrypt'

class Api::V1::UsersController < ApiController
  include BCrypt

  def index
  end
  def new
  end
  def create
    # debugger
    password_bool = params[:password] == params[:password_confirmation]
    user_name_bool = User.find_by(user_name: params[:user_name]).nil?
    email_bool = User.find_by(email: params[:email]).nil?

    if password_bool && user_name_bool && email_bool
      pass_hash = Password.create(params[:password])
      # BCrypt overrides ==
      # We can compare: HASH == plaintext
      @user = User.new(user_name: params[:user_name], email: params[:email], password_hash: pass_hash)
      @user.save!
      render json: @user, except: [:id, :password_hash, :created_at, :updated_at]
      # HTTP: send user_name and email to frontend
    else
      debugger
      # HTTP :return errors
    end
    # throw error if:
    #   user_name already exists
    #   email already exists
    #   password doesnt match
    # user = User.new(params)
    # else save
  end
end
