module RequestHelpers
  def self.json(resp_body)
    JSON.parse resp_body
  end
end
