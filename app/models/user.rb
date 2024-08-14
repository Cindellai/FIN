# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  bio                    :text
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  last_name              :string
#  profile_picture        :string
#  rating                 :float
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :boolean          default(FALSE)
#  username               :string           default(""), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :subscriptions
  has_many :subscribed_traders, through: :subscriptions, source: :trader

  has_many :trades, foreign_key: :poster_id, class_name: 'Trade'
  has_many :posts, foreign_key: :user_id, class_name: 'Post'
  has_many :comments

  # Subscribers association
  has_many :received_subscriptions, foreign_key: :trader_id, class_name: 'Subscription'
  has_many :subscribers, through: :received_subscriptions, source: :user

   # File uploads
   has_one_attached :profile_picture
   has_one_attached :banner_image

  # Validations
  validates :username, presence: true, uniqueness: true
  validates :first_name, presence: true 
  validates :last_name, presence: true

  # Scope to get only traders
  scope :traders, -> { where(role: true) }
  # Scope to get only students
  scope :students, -> { where(role: false) }
  
  # Methods to check user roles
  def creator?
    role == true
  end

  def novice?
    role == false
  end

  def feed_posts
    Post.where(user_id: subscribed_traders.pluck(:id)).order(created_at: :desc)



end
end
