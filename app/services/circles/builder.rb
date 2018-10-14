module Circles
  class Builder
    def self.save_circle(circle_params, request_valid)
      circle = Circle.new(circle_name: circle_params[:circle_name],
                          budget: circle_params[:budget],
                          exchange_date: circle_params[:exchange_date],
                          user_id: request_valid,
                          owner: circle_params[:user_name])
      circle.save!
      circle
    end
    def self.validate(user_name, auth_hash)
      user = User.find_by(user_name: user_name)
      auth_token = AuthToken.find_by(auth_hash: auth_hash)
      if auth_token and user
        if auth_token.user_id == user.id and auth_token.expiry > DateTime.now
          # returns user id to be used later on
          # to avoid querying again
          return user.id
        end
      end

      return false
    end
  end
end
