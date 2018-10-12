class AddCircleIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :circle_id, :integer
  end
end
