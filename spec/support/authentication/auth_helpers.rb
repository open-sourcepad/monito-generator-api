module AuthHelpers
  def self.create_user(email, password)
    user_fact = FactoryBot.create(:user, email: email, password_hash: Password.create(password))
  end
end
