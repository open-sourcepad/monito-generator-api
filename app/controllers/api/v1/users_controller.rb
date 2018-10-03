class Api::V1::UsersController < ApiController
  def index
  end
  def new
  end
  def create
    # debugger
    # user_name_bool = User.find_by(user_name: params[:user_name])
    # email_bool = User.find_by(email: params[:email])

    # throw error if:
    #   user_name already exists
    #   email already exists
    #   password doesnt match
    # user = User.new(params)
    # else save
  end
end
