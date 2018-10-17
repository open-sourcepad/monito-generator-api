class CreateUserCircles < ActiveRecord::Migration[5.2]
  def change
    create_table :user_circles do |t|

      t.timestamps
    end
  end
end
