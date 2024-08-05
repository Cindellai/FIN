class AddPostIdToTrades < ActiveRecord::Migration[7.1]
  def change
    add_column :trades, :post_id, :integer
  end
end
