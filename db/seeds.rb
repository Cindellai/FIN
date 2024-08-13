require 'faker'

# Clear existing data
Comment.destroy_all
Trade.destroy_all
Post.destroy_all
Subscription.destroy_all
User.destroy_all

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
    bio: Faker::Lorem.sentence,
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
    bio: Faker::Lorem.sentence,
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

# Create posts for each creator
creators.each do |user|
  10.times do
    post_type = ['article', 'video', 'trade_idea'].sample

    body_content = case post_type
                   when 'article'
                     [
                       "#{Faker::Lorem.paragraph(sentence_count: 3, supplemental: true, random_sentences_to_add: 4)} Effective #{Faker::Finance.stock_market} investment strategies are essential for growth. Understanding market trends and making informed decisions can significantly impact your portfolio's performance.",
                       "#{Faker::Lorem.paragraph(sentence_count: 3, supplemental: true, random_sentences_to_add: 4)} Diversification is key to minimizing risks in the stock market. By spreading investments across various sectors, you can protect your assets from market volatility.",
                       "#{Faker::Lorem.paragraph(sentence_count: 3, supplemental: true, random_sentences_to_add: 4)} Long-term investments in blue-chip stocks have historically provided stable returns. While they may not be as exciting as high-risk, high-reward trades, they offer security and steady growth over time.",
                       "#{Faker::Lorem.paragraph(sentence_count: 3, supplemental: true, random_sentences_to_add: 4)} Analyzing financial statements is a crucial step in evaluating a company's potential. By understanding a company's balance sheet, income statement, and cash flow, investors can make informed decisions about their stock purchases."
                     ].sample
                   when 'video'
                     [
                       "Check out this comprehensive video on long-term investing strategies and market analysis. Learn how to navigate the ups and downs of the stock market.",
                       "Watch this video tutorial on reading and interpreting stock charts to improve your trading strategies.",
                       "This video covers the basics of options trading, including how to use options to hedge your portfolio and maximize profits.",
                       "Learn about the latest market trends and forecasts in this in-depth video analysis."
                     ].sample
                   when 'trade_idea'
                     [
                       "Consider this trade idea: Investing in #{Faker::Finance.stock_market} stocks could yield significant returns given the current market conditions. Keep an eye on economic indicators and company earnings reports.",
                       "Trade alert: #{Faker::Finance.stock_market} stocks are showing strong momentum. This could be a good entry point for growth-oriented investors.",
                       "With the recent downturn in tech stocks, now might be the time to buy into #{Faker::Finance.stock_market}. Consider a dollar-cost averaging strategy to mitigate risks.",
                       "Given the current inflation rates, #{Faker::Finance.stock_market} stocks could provide a hedge against devaluation. Focus on companies with strong cash flow and pricing power."
                     ].sample
                   else
                     Faker::Lorem.paragraph(sentence_count: 3, supplemental: true, random_sentences_to_add: 4)
                   end

    post = user.posts.create!(
      title: Faker::Lorem.sentence(word_count: 3, supplemental: true),
      post_type: post_type,
      body: body_content,
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

puts "Seeded #{User.count} users, #{Post.count} posts, #{Trade.count} trades, #{Subscription.count} subscriptions."
