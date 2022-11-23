class AddIndexToBlockedRegistrationNumberRegistrationNumber < ActiveRecord::Migration[7.0]
  def change
    add_index :blocked_registration_numbers, :registration_number, unique:true
  end
end
