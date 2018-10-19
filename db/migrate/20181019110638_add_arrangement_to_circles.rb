class AddArrangementToCircles < ActiveRecord::Migration[5.2]
  def change
    add_column :circles, :arrangement, :string
  end
end
