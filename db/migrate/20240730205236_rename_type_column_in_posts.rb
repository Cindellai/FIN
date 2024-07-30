class RenameTypeColumnInPosts < ActiveRecord::Migration[7.1]
  def change
    rename_column :posts, :type, :content_type
  end
end
