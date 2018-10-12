class CreateCirclesUserJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_join_table :circles, :users do |t|
      t.index :circle_id
      t.index :user_id
    end
  end
end
