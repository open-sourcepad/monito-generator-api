require 'bcrypt'
class User < ApplicationRecord
  include BCrypt
  include Authentication

  validates :user_name, presence: true, uniqueness: { case_sensitive: true }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password_hash, presence: true

  has_many :user_circles
  has_many :circles, :through => :user_circles
end
