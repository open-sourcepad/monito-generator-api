require 'bcrypt'
module Sessions
  class Authenticator
    include BCrypt

    def self.validate(params)
      errors = {}
      user_valid = false

      user = User.find_by(email: params[:email])
      pass_check = (Password.new(user.password_hash) == params[:password]) if user
      user_valid = true if (user and pass_check)
      errors["user_error"] = "Invalid email and password combination" if !user_valid

      errors
    end

    def self.login(params)
      user = User.find_by(email: params[:email])
      auth_hash = AuthTokens::Builder.gen_hash
      auth_token = AuthTokens::Builder.generate(user.id, auth_hash)
      {'user_name': user.user_name, 'auth_hash': auth_hash}
    end
  end
end
