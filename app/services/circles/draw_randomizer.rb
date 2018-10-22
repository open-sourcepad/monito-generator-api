module Circles
  class DrawRandomizer
    def self.randomize_draw(circle_id)
      circle = Circle.find(circle_id)
      userscircles_in_circle = UserCircle.where(circle_id: circle_id)

      # randomized for monito-monita
      users_in_circle_ids = userscircles_in_circle.pluck(:user_id).shuffle
      users_in_circle_ids_str = users_in_circle_ids.to_s
      circle.update(arrangement: users_in_circle_ids_str)

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
    def self.get_codenames_usercircles(circle_id, users_ids)
      usercircles = []
      users_ids.each do |id|
        usercircle = UserCircle.find_by(circle_id: circle_id, user_id: id)
        if usercircle
          usercircles.push(usercircle)
        end
      end
      codenames = usercircles.pluck(:code_name)
      [codenames, usercircles]
    end
    def self.display_codenames(codename_list)
      out = []
      codename_list.each_with_index do |codename, i|
        if i == 0
          out.push(codename)
        else
          out.push(codename)
          out.push(codename)
        end
      end
      out.push(codename_list[0])
      out
    end
  end 
end
