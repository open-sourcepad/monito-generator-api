class Circle < ApplicationRecord
  has_many :user_circles
  has_many :users, :through => :user_circles
end
