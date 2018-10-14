class AddOwnerToCircles < ActiveRecord::Migration[5.2]
  def change
    add_column :circles, :owner, :string
  end
end
