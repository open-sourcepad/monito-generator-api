class AddWishlistToUserCircles < ActiveRecord::Migration[5.2]
  def change
    add_column :user_circles, :wishlist, :string
  end
end
