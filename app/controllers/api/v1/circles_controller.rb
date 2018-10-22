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
      UserCircles::CodenameBuilder.build_codename(circle['owner'], circle['id'], params['code_name'])
      render json: circle
    else
      render json: {"error": true}
    end
  end

  def show
    circle = Circle.find(params['id'])

    usercircles = UserCircle.where(circle_id: params['id'])
    usercircles_user_ids = usercircles.pluck(:user_id)

    accepted_users = User.where(id: usercircles_user_ids)
    accepted_emails = accepted_users.pluck(:email)
    out_hash = {'circle_found': circle.as_json(:only => [:id, :circle_name,:budget, :exchange_date, :owner, :arrangement]),
                'accepted_emails': accepted_emails
               }
    if circle['arrangement']
      users = Circles::DrawRandomizer.get_arranged_users(params['id'])
      users_ids = users.pluck(:id)

      users_codenames = Circles::DrawRandomizer.get_codenames(params['id'], users_ids)
      # a function to loop the codenames for easy display and pairing up
      display_codenames = Circles::DrawRandomizer.display_codenames(users_codenames)
      out_hash['codename_arr'] = display_codenames
    end
    render json: out_hash
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
      # email_exists is a user_name of the returned email
      user_find = email_exists

      if email_exists
        UsersMailerWorker.perform_async(circle_hash, email, user_find['user_name'])
      else
        UsersMailerWorker.perform_async(circle_hash, email, '')
      end
    end
    render json: emails_hash

  end
  def generate_monito
    circle_id = params['circle_id']
    circle = Circle.find(circle_id)
    circle_hash = {'id': circle['id'],
                   'circle_name': circle['circle_name'],
                   'budget': circle['budget'],
                   'exchange_date': circle['exchange_date'],
                   'owner': circle['owner']}
    arrange_arr = Circles::DrawRandomizer.randomize_draw(circle_id)
    users = Circles::DrawRandomizer.get_arranged_users(circle_id)
    users_ids = users.pluck(:id)

    users_codenames = Circles::DrawRandomizer.get_codenames(circle_id, users_ids)
    users_emails = users.pluck(:email)
    Users::EmailPairer.pair_users(circle_hash, users_codenames, users_emails)

    render json: {codename_arr: users_codenames}
  end
end
