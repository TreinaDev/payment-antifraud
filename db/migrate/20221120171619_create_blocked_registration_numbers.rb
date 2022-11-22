class CreateBlockedRegistrationNumbers < ActiveRecord::Migration[7.0]
  def change
    create_table :blocked_registration_numbers do |t|
      t.string :registration_number
      t.timestamps
    end
  end
end
