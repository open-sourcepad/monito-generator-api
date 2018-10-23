class CreateUserEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :user_events do |t|
      t.integer :user_id
      t.integer :circle_id
      t.date :exchange_date
      t.string :desc
      t.boolean :deadline

      t.timestamps
    end
  end
end
