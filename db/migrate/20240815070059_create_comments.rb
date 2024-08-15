class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.text :body
      t.references :user, null: false, foreign_key: true
      t.references :post, null: true, foreign_key: true
      t.references :trade, null: true, foreign_key: true

      t.timestamps
    end

    change_column_null :comments, :trade_id, true
    change_column_null :comments, :post_id, true
  end
end
