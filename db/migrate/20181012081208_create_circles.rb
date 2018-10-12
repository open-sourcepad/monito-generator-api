class CreateCircles < ActiveRecord::Migration[5.2]
  def change
    create_table :circles do |t|
      t.string :circle_name
      t.string :budget
      t.date :exchange_date

      t.timestamps
    end
  end
end
