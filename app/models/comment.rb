# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint
#  trade_id   :bigint
#  user_id    :bigint           not null
#
# Indexes
#
#  index_comments_on_post_id   (post_id)
#  index_comments_on_trade_id  (trade_id)
#  index_comments_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (trade_id => trades.id)
#  fk_rails_...  (user_id => users.id)
#
class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  # Optionally, if you want comments to be deleted when a post is deleted:
  # belongs_to :post, dependent: :destroy
end

