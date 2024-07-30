class CreateTrades < ActiveRecord::Migration[7.1]
  def change
    create_table :trades do |t|
      t.references :poster, null: false, foreign_key: { to_table: :users }
      t.string :stock_name
      t.datetime :executed_at
      t.float :performance
      t.string :buy_or_sell
      t.integer :quantity
      t.decimal :price, precision: 10, scale: 2
      t.text :description

      t.timestamps
    end
  end
end
