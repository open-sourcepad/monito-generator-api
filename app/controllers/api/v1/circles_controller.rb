class Api::V1::CirclesController < ApiController

  def index
    user = User.find_by(user_name: params[:user_name])
    circles = Circle.where(user_id: user.id)
    render json: {'circles': circles}
  end
  def create
  # replace this with http headers
    request_valid = Circles::Builder.validate(params['user_name'], params['auth_hash'])
    if request_valid
      # request_valid returns the user's id if request was valid
      circle = Circles::Builder.save_circle(params, request_valid)
      render json: circle
    else
      render json: {"error": true}
    end
  end

  def show
    circle = Circle.find(params['id'])

    render json: {'circle_found': circle.as_json(:only => [:id, :circle_name,:budget, :exchange_date, :owner])}
  end
  def send_emails
    users = params['invitations']['users']
    circle = params['current_circle']
    circle_hash = {'id': circle['id'],
                   'circle_name': circle['circle_name'],
                   'budget': circle['budget'],
                   'exchange_date': circle['exchange_date'],
                   'owner': circle['owner']
    }

    users.each do |user|
      email = user['email']
      UsersMailerWorker.perform_async(circle_hash, email)
    end
  end
end
