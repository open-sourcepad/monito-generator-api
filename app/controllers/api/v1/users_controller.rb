require 'bcrypt'

class Api::V1::UsersController < ApiController
  include BCrypt

  def index
  end
  def new
  end
  def create
    # pass the params to the error checker
    errors = Users::ErrorChecker.check_errors(params)
    if errors.empty?
      user_store = Users::Builder.reg_and_login(params)
      render json: user_store
    else
      render json: errors
    end
  end
  def login
  end
end
