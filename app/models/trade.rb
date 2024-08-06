# == Schema Information
#
# Table name: trades
#
#  id          :bigint           not null, primary key
#  buy_or_sell :string
#  description :text
#  executed_at :datetime
#  performance :float
#  price       :decimal(10, 2)
#  quantity    :integer
#  stock_name  :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  post_id     :integer
#  poster_id   :bigint           not null
#
# Indexes
#
#  index_trades_on_poster_id  (poster_id)
#
# Foreign Keys
#
#  fk_rails_...  (poster_id => users.id)
#
class Trade < ApplicationRecord
  belongs_to :post
  belongs_to :poster, class_name: 'User'
  has_many :comments

  #validates :stock_name, :executed_at, :performance, :buy_or_sell, :quantity, :price, :description, presence: true
end
