class Api::V1::CirclesController < ApiController

  def create
  # replace this with http headers
  request_valid = Circles::Builder.validate(params['user_name'], params['auth_hash'])
  if request_valid
    # request_valid returns the user's id if request was valid
    circle = Circles::Builder.save_circle(params, request_valid)
    render json: circle
  else
    render json: {"error": true}
  end
  end

end
