module UserCircles
  class EntryBuilder
    def self.build_entry(user_name, circle_id, code_name, wishlist)
      user = User.find_by(user_name: user_name)
      user_id = user.id
      usercircle = UserCircle.find_by(user_id: user_id, circle_id: circle_id)
      wish_list = []
      wishlist.each do |wish_hold|
        wish_list.append(wish_hold['wish'])
      end
      usercircle.update(code_name: code_name, wishlist: wish_list.to_s)
    end
  end
end

