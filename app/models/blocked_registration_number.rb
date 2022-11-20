class BlockedRegistrationNumber < ApplicationRecord
  validates :registration_number, presence: true, length: { is: 11 }, numericality: { only_integer: true }
end
