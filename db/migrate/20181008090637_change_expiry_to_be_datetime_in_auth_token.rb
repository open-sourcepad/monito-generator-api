class ChangeExpiryToBeDatetimeInAuthToken < ActiveRecord::Migration[5.2]
  def change
    change_column :auth_tokens, :expiry, :datetime
  end
end
