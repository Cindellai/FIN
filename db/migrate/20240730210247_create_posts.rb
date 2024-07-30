class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :content_type
      t.string :url
      t.text :body
      t.references :posted_by, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
