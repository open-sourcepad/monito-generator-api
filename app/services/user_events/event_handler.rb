module UserEvents
  class EventHandler
    def self.add_event(user_name, circle_id, desc)
      user = User.find_by(user_name: user_name)
      circle = Circle.find(circle_id)
      final_date = if desc then true else false end
      user_event = UserEvent.new(user_id: user.id, circle_id: circle_id, exchange_date: circle['exchange_date'], desc: desc, deadline: final_date, circle_name: circle['circle_name'])
      user_event.save!
      user_event
    end
    def self.get_upcoming_events(user_name)
      user = User.find_by(user_name: user_name)
      user_events = UserEvent.where(user_id: user.id).order('exchange_date ASC')
    end
  end
end
