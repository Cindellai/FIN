# == Schema Information
#
# Table name: subscriptions
#
#  id         :bigint           not null, primary key
#  duration   :integer
#  price      :decimal(10, 2)
#  status     :string
#  tier       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  trader_id  :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_subscriptions_on_trader_id  (trader_id)
#  index_subscriptions_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (trader_id => users.id)
#  fk_rails_...  (user_id => users.id)
#
class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :trader, class_name: 'User'

  validates :tier, :price, :duration, :status, presence: true
end
