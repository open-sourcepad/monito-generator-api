require 'bcrypt'

class Api::V1::UsersController < ApiController
  include BCrypt
  def create
    # skip error check if user exists
    if params['user_exists']
      errors = []
    else
      # pass the params to the error checker
      errors = Users::ErrorChecker.check_errors(params)
    end

    if errors.empty?
      user_store = Users::Builder.reg_and_login(params)
      if params['invited_by']
        circle_name = Circle.find(params['invited_by'])['circle_name']
        user_store['circle_invitation'] = circle_name;
        Circles::ConnectionAdder.add_connection(params['user_name'], params['invited_by'])
        UserCircles::EntryBuilder.build_entry(params['user_name'], params['invited_by'], params['code_name'], params['wishes'])
        UserEvents::EventHandler.add_event(params['user_name'], params['invited_by'], nil)

      end

      render json: user_store
    else
      render json: errors
    end
  end
end
