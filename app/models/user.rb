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

  # Subscribers association
  has_many :received_subscriptions, foreign_key: :trader_id, class_name: 'Subscription'
  has_many :subscribers, through: :received_subscriptions, source: :user

  # Validations
  validates :username, presence: true, uniqueness: true

  # Scope to get only traders
  scope :traders, -> { where(role: true) }
  # Scope to get only students
  scope :students, -> { where(role: false) }
  
  # Methods to check user roles
  def trader?
    role == true
  end

  def student?
    role == false
  end
end
