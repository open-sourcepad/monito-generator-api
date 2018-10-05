class CreateAuthTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :auth_tokens do |t|
      t.integer :user_id
      t.date :expiry
      t.string :auth_hash

      t.timestamps
    end
  end
end
