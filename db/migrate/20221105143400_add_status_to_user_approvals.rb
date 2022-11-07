class AddStatusToUserApprovals < ActiveRecord::Migration[7.0]
  def change
    add_column :user_approvals, :status, :boolean
  end
end
