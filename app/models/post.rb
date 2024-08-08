# == Schema Information
#
# Table name: posts
#
#  id           :bigint           not null, primary key
#  body         :text
#  content_type :string
#  post_type    :string
#  title        :string
#  url          :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Post < ApplicationRecord
  belongs_to :user
  has_one :trade, dependent: :destroy                                           
  validates :title, presence: true
  validates :body, presence: true, if: -> { post_type != 'trade_idea' }
  validates :post_type, presence: true
  accepts_nested_attributes_for :trade, allow_destroy: true
  has_one_attached :file
end
 