class CreateUserApprovals < ActiveRecord::Migration[7.0]
  def change
    create_table :user_approvals do |t|
      t.string :refusal
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
