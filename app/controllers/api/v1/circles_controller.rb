class Api::V1::CirclesController < ApiController

  def index
    user = User.find_by(user_name: params[:user_name])
    circles = user.circles.order('created_at DESC')
    render json: {'circles': circles}
  end
  def create
  # replace this with http headers
    request_valid = Circles::Builder.validate(params['user_name'], params['auth_hash'])
    if request_valid
      # request_valid returns the user's id if request was valid
      circle = Circles::Builder.save_circle(params, request_valid)
      Circles::ConnectionAdder.add_connection(circle['owner'],circle['id'])
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
                   'owner': circle['owner']}
    emails_hash = {'existing_emails': []}

    users.each do |user|
      email = user['email']
      email_exists = Users::ExistChecker.check_user(email)

      if email_exists
        emails_hash['existing_emails'].push(email)
      else
        UsersMailerWorker.perform_async(circle_hash, email)
      end
    end
    render json: emails_hash

  end
end
