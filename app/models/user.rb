class User < ApplicationRecord
  validates :user_name, presence: true, uniqueness: { case_sensitive: true }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password_hash, presence: true


  def self.register(user_name, email, password, password_confirmation)
    # checks if password and password_confirmation is the same
    password_bool = password == password_confirmation
    # checks if user_name is already taken
    user_name_bool = User.find_by(user_name: user_name).nil?
    # checks if email is already taken
    email_bool = User.find_by(email: email).nil?

    if password_bool && user_name_bool && email_bool
      pass_hash = Password.create(password)
      # BCrypt overrides ==
      # We can compare: HASH == plaintext
      @user = User.new(user_name: params[:user_name], email: params[:email], password_hash: pass_hash)
      @user.save!
      # registration succesful
      #binding.pry
      @user

    else
      @errors = {}

      if !password_bool
        @errors['pass_error'] = "Password Does not Match"
      end
      if !user_name_bool
        @errors['user_error'] = "User Name is already taken"
      end
      if !email_bool
        @errors['email_error'] = "Email is already taken"
      end
      # registration unsucccesful
      #binding.pry
      @errors

    end
  end

end
