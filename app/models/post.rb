# == Schema Information
#
# Table name: posts
#
#  id           :bigint           not null, primary key
#  body         :text
#  content_type :string
#  title        :string
#  url          :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  posted_by_id :bigint           not null
#
# Indexes
#
#  index_posts_on_posted_by_id  (posted_by_id)
#
# Foreign Keys
#
#  fk_rails_...  (posted_by_id => users.id)
#
class Post < ApplicationRecord
  belongs_to :user, foreign_key: :posted_by_id

  validates :title, presence: true
  validates :body, presence: true
end
