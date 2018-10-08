module Users
  module ErrorChecker
    def self.check_errors(params)
      errors = {}

      user_bool = !User.find_by(user_name: params[:user_name]).nil?
      email_bool = !User.find_by(email: params[:email]).nil?
      password_bool = params[:password] != params[:password_confirmation]

      errors["user_error"] = 'User Name is already taken' if user_bool
      errors["email_error"] = 'Email is already taken' if email_bool
      errors["pass_error"] =  'Password does not match' if password_bool
      
      errors
    end
  end
end
