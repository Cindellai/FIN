require 'faker'
require 'open-uri'

# Clear existing data
Comment.destroy_all
Trade.destroy_all
Post.destroy_all
Subscription.destroy_all
User.destroy_all

# Sample profile pictures
profile_pictures = [
  "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=880&h=880&q=80",
  "https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=faceare&facepad=3&w=688&h=688&q=100"
]

# Create specific creators
creators = []
4.times do |i|
  user = User.create!(
    username: Faker::Internet.username,
    bio: Faker::Lorem.sentence,
    email: Faker::Internet.email,
    password: 'password',
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    role: true # Indicating creator status
  )

  # Attach profile picture
  file = URI.open(profile_pictures.sample)
  user.profile_picture.attach(io: file, filename: "profile_picture#{i}.jpg", content_type: 'image/jpg')

  creators << user
end

# Create posts for the specific creators
creators.each do |user|
  5.times do
    post_type = ['article', 'video', 'trade_idea'].sample

    body_content = case post_type
                   when 'article'
                     Faker::Lorem.paragraph
                   when 'video'
                     "Video content placeholder"
                   when 'trade_idea'
                     "Trade idea content placeholder"
                   else
                     Faker::Lorem.paragraph
                   end

    post = user.posts.create!(
      title: Faker::Lorem.sentence,
      post_type: post_type,
      body: body_content,
      url: post_type == 'video' ? Faker::Internet.url : nil
    )

    if post_type == 'trade_idea'
      trade = post.create_trade!(
        stock_name: Faker::Finance.stock_market,
        executed_at: Faker::Date.between(from: 1.year.ago, to: Date.today),
        performance: rand(1.0..100.0),
        buy_or_sell: ['buy', 'sell'].sample,
        quantity: rand(1..1000),
        price: Faker::Commerce.price(range: 1.0..1000.0),
        description: Faker::Lorem.paragraph,
        poster: user # Assuming poster refers to the user who created the trade
      )
    end
  end
end

# Create additional users
additional_users = []
16.times do |i|
  is_creator = false # Additional users are not creators
  user = User.create!(
    username: Faker::Internet.username,
    bio: Faker::Lorem.sentence,
    email: Faker::Internet.email,
    password: 'password',
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    role: is_creator # Indicating non-creator status
  )

  # Attach profile picture
  file = URI.open(profile_pictures.sample)
  user.profile_picture.attach(io: file, filename: "profile_picture#{i + 4}.jpg", content_type: 'image/jpg')

  additional_users << user
end

users = creators + additional_users

# Create subscriptions
additional_users.each do |user|
  subscribed_creators = creators.sample(2) # Each non-creator subscribes to 2 random specific creators

  subscribed_creators.each do |creator|
    Subscription.create!(
      user: user,
      trader: creator,
      tier: ['free', 'premium'].sample,
      price: Faker::Commerce.price(range: 10.0..100.0),
      duration: rand(1..12),
      status: 'active'
    )
  end
end

puts "Seeded #{User.count} users, #{Post.count} posts, #{Trade.count} trades, #{Subscription.count} subscriptions."
