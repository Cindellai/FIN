# db/seeds.rb

require 'faker'

# Clear existing data
Comment.destroy_all
Trade.destroy_all
Post.destroy_all
Subscription.destroy_all
User.destroy_all

# Create specific creators
creators = []
4.times do |i|
  user = User.create!(
    username: Faker::Internet.username,
    bio: Faker::Lorem.sentence,
    email: Faker::Internet.email,
    password: 'password',
    role: true # Indicating creator status
  )

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

      # Create comments for each trade
      5.times do
        Comment.create!(
          user: creators.sample, # Random user for comments
          trade: trade,
          post: post,
          body: Faker::Lorem.sentence
        )
      end
    end

    # Create comments for each post
    5.times do
      Comment.create!(
        user: creators.sample, # Random user for comments
        post: post,
        body: Faker::Lorem.sentence
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
    role: is_creator # Indicating non-creator status
  )

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

puts "Seeded #{User.count} users, #{Post.count} posts, #{Trade.count} trades, #{Subscription.count} subscriptions, and #{Comment.count} comments."
