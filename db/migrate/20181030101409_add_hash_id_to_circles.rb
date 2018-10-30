class AddHashIdToCircles < ActiveRecord::Migration[5.2]
  def up
    add_column :circles, :hash_id, :string, index: true
    Circle.all.each{|m| m.set_hash_id; m.save}
   end
   def down
    remove_column :circles, :hash_id, :string
   end
end
