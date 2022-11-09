class AddStatusDefaultToUserApproval < ActiveRecord::Migration[7.0]
  def change
    change_column_default :user_approvals, :status, from: nil, to: :refused
  end
end
