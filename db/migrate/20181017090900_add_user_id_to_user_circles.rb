class AddUserIdToUserCircles < ActiveRecord::Migration[5.2]
  def change
    add_column :user_circles, :user_id, :integer
  end
end
