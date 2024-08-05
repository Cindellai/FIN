class RenamePostedByIdToUserIdInPosts < ActiveRecord::Migration[7.1]
  def change
    rename_column :posts, :posted_by_id, :user_id
  end
end
