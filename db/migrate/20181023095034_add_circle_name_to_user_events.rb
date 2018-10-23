class AddCircleNameToUserEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :user_events, :circle_name, :string
  end
end
