module Users
  class ExistChecker
    def self.check_user(email)
      user_bool = User.find_by(email: email)
    end
  end
end
