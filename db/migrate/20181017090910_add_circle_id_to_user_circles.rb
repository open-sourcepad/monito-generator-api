class AddCircleIdToUserCircles < ActiveRecord::Migration[5.2]
  def change
    add_column :user_circles, :circle_id, :integer
  end
end
