require 'bcrypt'

class Api::V1::UsersController < ApiController
  include BCrypt
  def create
    # pass the params to the error checker
    errors = Users::ErrorChecker.check_errors(params)
    if errors.empty?
      user_store = Users::Builder.reg_and_login(params)
      if params['invited_by']
        Circles::ConnectionAdder.add_connection(params['user_name'], params['invited_by'])
      end

      render json: user_store
    else
      render json: errors
    end
  end
  def login
  end
end
