# == Schema Information
#
# Table name: posts
#
#  id           :bigint           not null, primary key
#  body         :text
#  content_type :string
#  post_type    :string
#  title        :string
#  topic        :string
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
  has_many :comments, dependent: :destroy # This line establishes the relationship
  has_one :trade, dependent: :destroy        
  has_one_attached :file

  validates :title, presence: true
  validates :body, presence: true, if: -> { post_type != 'trade_idea' }
  validates :post_type, presence: true
  validate :correct_file_mime_type

  accepts_nested_attributes_for :trade, allow_destroy: true


  private

  def correct_file_mime_type
    if file.attached? && !file.content_type.in?(%w(video/mp4))
      errors.add(:file, 'must be an MP4 file')
      file.purge
    end
  end

  scope :trending_topics, -> {
    where.not(topic: nil) # Exclude posts with nil topics
      .group(:topic)
      .order('COUNT(topic) DESC')
      .limit(5) # Apply limit here within the scope
      .pluck(:topic) # Pluck only the topic names, this will return an array of topics
  }
end
 
