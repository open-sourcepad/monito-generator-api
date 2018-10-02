class User < ApplicationRecord
  validates :user_name, presence: true, uniqueness: { case_sensitive: true }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password_hash, presence: true
end
