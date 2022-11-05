class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum status: { pending: 0, approved: 1 }

  has_one :user_approval
end
