# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  bio                    :text
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
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
  has_many :posts, foreign_key: :posted_by, class_name: 'Post'
  has_many :comments

  # Validations
  validates :username, presence: true, uniqueness: true

  # Scope to get only traders
  scope :traders, -> { where(role: true) }
  # Scope to get only students
  scope :students, -> { where(role: false) }
end
