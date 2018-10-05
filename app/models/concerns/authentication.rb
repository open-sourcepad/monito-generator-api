module Authentication
  def gen_hash
    fresh_hash = new_hash
    hash_bool = AuthToken.find_by(auth_hash: fresh_hash)

    while !hash_bool.nil?
      fresh_hash = new_hash
      hash_bool = AuthToken.find_by(auth_hash: fresh_hash)
    end

    fresh_hash
  end

  def new_hash
    fresh_hash = SecureRandom.hex
  end
end
