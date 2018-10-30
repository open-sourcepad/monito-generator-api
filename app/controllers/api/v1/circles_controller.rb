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
      render json: {'success': true}
    else
      render json: {'error': true}
    end
  end

  def show
    circle = Circle.friendly.find(params['id'])

    usercircles = UserCircle.where(circle_id: circle.id)
    usercircles_user_ids = usercircles.pluck(:user_id)

    accepted_users = User.where(id: usercircles_user_ids)
    accepted_emails = accepted_users.pluck(:email)
    user_events = UserEvent.where(circle_id: circle.id)

    out_hash = {'circle_found': circle.as_json(:only => [:circle_name,:budget, :exchange_date, :owner, :arrangement, :hash_id]),
                'accepted_emails': accepted_emails,
                'user_events': user_events
               }

    if circle['arrangement']
      users = Circles::DrawRandomizer.get_arranged_users(circle.id)
      users_ids = users.pluck(:id)

      users_codenames = Circles::DrawRandomizer.get_codenames_usercircles(circle.id, users_ids)[0]
      # a function to loop the codenames for easy display and pairing up
      display_codenames = Circles::DrawRandomizer.display_codenames(users_codenames)
      out_hash['codename_arr'] = display_codenames
    end
    render json: out_hash
  end

  def edit
    circle = Circle.friendly.find(params['id'])
    owner = User.find(circle['user_id'])
    owner_user_circle = UserCircle.find_by(user_id: owner['id'], circle_id: circle.id)
    user_circles = UserCircle.where('circle_id': circle.id)
    user_events = UserEvent.where('circle_id': circle.id)
    render json: { 'circle': circle,
                   'owner_user_circle': owner_user_circle,
                   'user_circles': user_circles,
                   'user_events': user_events }
  end
  def update
    request_valid = Circles::Builder.validate(params['user_name'], params['auth_hash'])

    circle = Circle.friendly.find(params['id'])
    owner = User.find_by(user_name: params['user_name'])
    owner_user_circle = UserCircle.find_by(user_id: owner.id, circle_id: circle.id)
    circle_user_event = UserEvent.find_by(user_id: owner.id, circle_id: circle.id, deadline: true)
    circle_user_event.update(circle_name: params['circle_name'],
                             exchange_date: params['exchange_date'])

    owner_user_circle.update(code_name: params['code_name'])
    UserEvents::EventHandler.clear_sub_events(circle.id)
    if params['user_events']
      params['user_events'].each_with_index do |user_event, i|
        UserEvents::EventHandler.add_event(circle['owner'], circle.id.to_i, params['user_events'][i]['userEvent'], params['user_events'][i]['exchange_date'])
      end
    end

    circle.update(circle_name: params['circle_name'],
                  budget: params['budget'],
                  exchange_date: params['exchange_date'])

    wishlist = []
    params['wish_list'].each do |wish_holder|
      wishlist.push(wish_holder['wish'])
    end
    owner_user_circle.update(wishlist: wishlist.to_s)

    if request_valid
      render json: {success: true}
    else
      render json: {error: true}
    end
  end

  def destroy
    circle = Circle.friendly.find(params['id'])
    circle.destroy
    user_circles = UserCircle.where('circle_id': circle.id)
    user_circles.destroy_all
    user_events = UserEvent.where('circle_id': circle.id)
    user_events.destroy_all

    render json:{'deleted_circle': circle['circle_name']}
  end
  def send_emails
    users = params['invitations']['users']
    circle = Circle.friendly.find(params['current_circle']['hash_id'])
    circle_hash = {'hash_id': circle.hash_id,
                   'circle_name': circle.circle_name,
                   'budget': circle.budget,
                   'exchange_date': circle.exchange_date,
                   'owner': circle.owner}
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
    circle = Circle.friendly.find(params['circle_id'])
    circle_id = circle.id
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
