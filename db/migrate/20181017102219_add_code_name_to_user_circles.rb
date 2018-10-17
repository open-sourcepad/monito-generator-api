class AddCodeNameToUserCircles < ActiveRecord::Migration[5.2]
  def change
    add_column :user_circles, :code_name, :string
  end
end
