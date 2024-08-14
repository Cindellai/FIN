class AddTopicToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :topic, :string
  end
end
