class AddUserIdToCircles < ActiveRecord::Migration[5.2]
  def change
    add_column :circles, :user_id, :integer
  end
end
