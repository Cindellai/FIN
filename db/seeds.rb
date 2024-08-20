require 'faker'

# Clear existing data
# db/seeds.rb

# Clear existing records
User.destroy_all
Post.destroy_all
Comment.destroy_all
Trade.destroy_all
Subscription.destroy_all


# Path to your 4 downloaded avatar images
avatar_files = [
  Rails.root.join('app/assets/images/avatars/avatar1.png'),
  Rails.root.join('app/assets/images/avatars/avatar2.png'),
  Rails.root.join('app/assets/images/avatars/avatar3.png'),
  Rails.root.join('app/assets/images/avatars/avatar4.png')
]

# Create specific creators
creators = []
30.times do |i|
  user = User.create!(
    username: Faker::Internet.username,
    bio: Faker::Quote.most_interesting_man_in_the_world,
    email: Faker::Internet.email,
    password: 'password',
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    role: true # Indicating creator status
  )

  # Attach one of the PNG avatars as the profile picture
  avatar_file = avatar_files.sample
  user.profile_picture.attach(io: File.open(avatar_file), filename: "profile_picture#{i}.png", content_type: 'image/png')

  creators << user
end

# Create 20 additional non-creator users
additional_users = []
20.times do |i|
  user = User.create!(
    username: Faker::Internet.username,
    bio: Faker::TvShows::SiliconValley.quote,
    email: Faker::Internet.email,
    password: 'password',
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    role: false # Indicating non-creator status
  )

  # Attach one of the PNG avatars as the profile picture
  avatar_file = avatar_files.sample
  user.profile_picture.attach(io: File.open(avatar_file), filename: "profile_picture#{i + 30}.png", content_type: 'image/png')

  additional_users << user
end

users = creators + additional_users

# Define potential topics
topics = ['Algorithmic Trading', 'Market Analysis', 'AI in Finance', 'Cryptocurrency', 'Python for Trading', 'Investment Strategies']

# Create posts for each creator
creators.each do |user|
  10.times do
    post_type = ['article', 'video', 'trade_idea'].sample
    topic = topics.sample

    body_content = case post_type
                   when 'article'
                     [
                       "Understanding the trends in the #{topic} field is crucial for predicting market movements. This article explores the latest techniques to maximize returns.",
                       "This deep dive into the latest #{topic} reveals key insights into investment opportunities that are emerging in the global market.",
                       "#{topic} is reshaping how we approach stock investments. This article covers essential strategies used by top investors.",
                       "For those interested in long-term growth, this analysis explores the fundamentals of value investing in today's volatile market."
                     ].sample
                   when 'video'
                     [
                       "Watch this in-depth tutorial on building a Python script for automated trading strategies. Perfect for those looking to get started with algo trading.",
                       "This video explores the top coding strategies used by quant traders. Learn how to implement these techniques to enhance your trading toolkit.",
                       "Check out this guide on optimizing your trading algorithms using the latest in AI and machine learning.",
                       "Explore the intersection of coding and finance in this comprehensive video on creating a backtesting framework for your trading strategies."
                     ].sample
                   when 'trade_idea'
                     [
                       "Considering #{Faker::Finance.stock_market} for your next trade? Here's why #{Faker::Company.name} might be a solid choice based on current market trends.",
                       "The recent dip in #{Faker::Company.name} presents an interesting buying opportunity. Here's why it might be worth a closer look.",
                       "With stocks showing volatility, a long-term position in #{Faker::Finance.stock_market} might provide a safer return.",
                       "Given the current economic climate, investing in key sectors like #{Faker::Company.name} might hedge against inflation."
                     ].sample
                   else
                     Faker::Lorem.paragraph(sentence_count: 3, supplemental: true, random_sentences_to_add: 4)
                   end

    post = user.posts.create!(
      title: "#{topic} Strategies for #{Faker::Company.name}",  # Relevant finance/trading title
      post_type: post_type,
      body: body_content,
      topic: topic,
      url: post_type == 'video' ? Faker::Internet.url(host: 'example.com') : nil
    )

    if post_type == 'trade_idea'
      post.create_trade!(
        stock_name: Faker::Finance.stock_market,
        executed_at: Faker::Date.between(from: 1.year.ago, to: Date.today),
        performance: rand(1.0..100.0),
        buy_or_sell: ['buy', 'sell'].sample,
        quantity: rand(1..1000),
        price: Faker::Commerce.price(range: 1.0..1000.0),
        description: Faker::Lorem.paragraph,
        poster: user
      )
    end

    # Create comments for the post
    rand(2..5).times do
      post.comments.create!(
        user: users.sample,
        body: Faker::Lorem.sentence(word_count: 10)
      )
    end
  end
end

# Create subscriptions for each user (creator and non-creator) to 10 random creators
users.each do |user|
  subscribed_creators = creators.sample(10) # Each user subscribes to 10 random creators

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

puts "Seeded #{User.count} users, #{Post.count} posts, #{Trade.count} trades, #{Subscription.count} subscriptions, #{Comment.count} comments."
