require 'bcrypt'
module Users
  class Builder
    include BCrypt

    def self.reg_and_login(params)
      # to be saved to the local storage
      out_params = {}
      if !params[:user_exists]
        pass_hash = Password.create(params[:password])
        user = User.new(user_name: params[:user_name],
                        email: params[:email],
                        password_hash: pass_hash
        )
        user.save!
      else
        user = User.find_by(user_name: params[:user_name])
      end
      # to be saved to the local storage
      auth_hash = AuthTokens::Builder.gen_hash
      # to be saved to the db
      auth_token = AuthTokens::Builder.generate(user.id, auth_hash)

      out_params['user_name'] = params[:user_name]
      out_params['auth_hash'] = auth_hash
      out_params
    end
  end
end
