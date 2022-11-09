class RenameUserApprovalToUserReview < ActiveRecord::Migration[7.0]
  def change
    rename_table :user_approvals, :user_reviews
  end
end
