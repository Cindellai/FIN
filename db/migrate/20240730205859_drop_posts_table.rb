class DropPostsTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :posts, if_exists: true, force: :cascade
  end
end
