module Circles
  class ConnectionAdder
    def self.add_connection(user_name, circle_id)
      user = User.find_by(user_name: user_name)
      circle = Circle.find(circle_id)

      user.circles << circle
    end
  end
end
