class ChangeStatusFromUserApprovalToInteger < ActiveRecord::Migration[7.0]
  def change
    change_column :user_approvals, :status, :integer
  end
end
