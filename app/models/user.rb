class User < ApplicationRecord
  validates :user_name, presence: true
  validates :email, presence: true
  validates :password_hash, presence: true
end
