module Circles
  class DrawRandomizer
    def self.randomize_draw(circle_id)
      userscircles_in_circle = UserCircle.where(circle_id: circle_id)

      # randomized for monito-monita
      users_in_circle_ids = userscircles_in_circle.pluck(:user_id).shuffle
      users_in_circle_ids_str = users_in_circle_ids.to_s
      Circle.update(arrangement: users_in_circle_ids_str)

      users_in_circle_ids
    end

    def self.get_arranged_users(circle_id)
      arrange_arr = JSON.parse(Circle.find_by(id: circle_id).arrangement)
      arrange_users = []

      arrange_arr.each do |id|
        user = User.find(id)
        arrange_users.push(user)
      end
      arrange_users
    end
    def self.get_codenames(circle_id, users_ids)
      usercircles = []
      users_ids.each do |id|
        usercircle = UserCircle.find_by(circle_id: circle_id, user_id: id)
        usercircles.push(usercircle)
      end
      codenames = usercircles.pluck(:code_name)
    end
  end 
end
