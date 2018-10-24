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
      UserCircles::EntryBuilder.build_entry(circle['owner'], circle['id'], params['code_name'], params['wish_list'])
      UserEvents::EventHandler.add_event(circle['owner'], circle['id'], nil, nil)
      if params['user_events']
        params['user_events'].each_with_index do |user_event, i|
          UserEvents::EventHandler.add_event(circle['owner'], circle['id'].to_i, params['user_events'][i]['userEvent'], params['user_events'][i]['exchange_date'])
        end
      end
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
    user_events = UserEvent.where(circle_id: params['id'])

    out_hash = {'circle_found': circle.as_json(:only => [:id, :circle_name,:budget, :exchange_date, :owner, :arrangement]),
                'accepted_emails': accepted_emails,
                'user_events': user_events
               }

    if circle['arrangement']
      users = Circles::DrawRandomizer.get_arranged_users(params['id'])
      users_ids = users.pluck(:id)

      users_codenames = Circles::DrawRandomizer.get_codenames_usercircles(params['id'], users_ids)[0]
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
        user_in_circle = Users::ExistChecker.in_group(email, circle['id'])
        if user_in_circle
          emails_hash[:existing_emails].push(email)
          next
        else
          UsersMailerWorker.perform_async(circle_hash, email, user_find['user_name'])
        end
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
    users_entries = Circles::DrawRandomizer.get_codenames_usercircles(circle_id, users_ids)
    users_codenames = users_entries[0]
    users_circles = users_entries[1]
    users_emails = users.pluck(:email)
    Users::EmailPairer.pair_users(circle_hash, users_codenames, users_circles, users_emails)

    render json: {codename_arr: users_codenames}
  end
end
