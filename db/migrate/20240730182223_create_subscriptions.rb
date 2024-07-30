class CreateSubscriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :trader, null: false, foreign_key: { to_table: :users }
      t.string :tier
      t.decimal :price, precision: 10, scale: 2
      t.integer :duration
      t.string :status

      t.timestamps
    end
  end
end
