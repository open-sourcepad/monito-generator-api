module UserEvents
  class EventHandler
    def self.add_event(user_name, circle_id, desc, draw_date)
      user = User.find_by(user_name: user_name)
      circle = Circle.find(circle_id)
      final_date = if desc then true else false end
      exchange_date = if draw_date then draw_date else circle['exchange_date'] end

      user_event = UserEvent.new(user_id: user.id, circle_id: circle_id, exchange_date: exchange_date, desc: desc, deadline: final_date, circle_name: circle['circle_name'])
      user_event.save!
      user_event
    end
    def self.get_upcoming_events(user_name)
      user = User.find_by(user_name: user_name)
      circles_ids = user.circles.pluck(:id)
      user_events = UserEvent.where(circle_id: circles_ids).order('exchange_date ASC')
    end
  end
end
