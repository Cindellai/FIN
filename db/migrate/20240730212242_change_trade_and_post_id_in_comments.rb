class ChangeTradeAndPostIdInComments < ActiveRecord::Migration[7.1]
  def change
    change_column_null :comments, :trade_id, true
    change_column_null :comments, :post_id, true
  end
end
