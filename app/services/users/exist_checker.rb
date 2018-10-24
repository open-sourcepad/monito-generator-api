module Users
  class ExistChecker
    def self.check_user(email)
      user_bool = User.find_by(email: email)
    end
    def self.in_group(email, circle_id)
      user = User.find_by(email: email)
      if user
        in_group = UserCircle.find_by(user_id: user['id'], circle_id: circle_id)
        if in_group
          user['email']
        else
          false
        end
      else
        false
      end
    end
  end
end
