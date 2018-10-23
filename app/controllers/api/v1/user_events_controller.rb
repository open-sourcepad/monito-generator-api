class Api::V1::UserEventsController < ApiController

  def index
    user_name = params['current_user']
    # only gets the top 3 to render on dashboard 
    user_events =  UserEvents::EventHandler.get_upcoming_events(user_name)
    user_events = user_events[0...3]

    render json: {'user_events': user_events}
  end
end
