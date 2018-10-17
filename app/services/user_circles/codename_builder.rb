module UserCircles
  class CodenameBuilder
    def self.build_codename(user_name, circle_id, code_name)
      user = User.find_by(user_name: user_name)
      user_id = user.id
      usercircle = UserCircle.find_by(user_id: user_id, circle_id: circle_id)
      usercircle.update(code_name: code_name)
    end
  end
end

