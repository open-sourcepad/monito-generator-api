module AuthTokens
  class Builder
    def self.gen_hash
      SecureRandom.hex
    end
    def self.generate(user_id, fresh_hash)
      auth_token = AuthToken.new(user_id:user_id,
                                 expiry: DateTime.now.next_day(7),
                                 auth_hash: fresh_hash)
      auth_token.save!
      auth_token
    end
  end
end
