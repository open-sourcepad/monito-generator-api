class Circle < ApplicationRecord
  has_many :user_circles
  has_many :users, :through => :user_circles
  has_many :user_events

  validates :circle_name, presence: true
  validates :budget, presence: true
  validates :exchange_date, presence: true
  validates :owner, presence: true
end
