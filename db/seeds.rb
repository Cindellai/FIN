# db/seeds.rb

# Clear existing data
User.destroy_all
Post.destroy_all
Subscription.destroy_all

# Create users
users = []
5.times do |i|
  is_creator = i.even? # Every alternate user is a creator
  user = User.create!(
    username: "user#{i + 1}",
    bio: "This is user#{i + 1}'s bio",
    email: "user#{i + 1}@example.com",
    password: "password",
    role: is_creator # Assuming role is a boolean
  )

  users << user
end

# Create posts only for creators
users.select { |user| user.role }.each do |user|
  3.times do
    post_type = ['article', 'video', 'trade_idea'].sample

    post = user.posts.create!(
      title: "Post by #{user.username}",
      post_type: post_type
    )

    if post_type == 'article'
      post.update(body: "This is a sample article by #{user.username}.")
    elsif post_type == 'video'
      post.update(url: "https://www.example.com/video")
    elsif post_type == 'trade_idea'
      post.create_trade!(
        stock_name: "AAPL",
        executed_at: Time.now,
        performance: rand(1.0..100.0),
        buy_or_sell: ['buy', 'sell'].sample,
        quantity: rand(1..1000),
        price: rand(1.0..1000.0),
        description: "This is a trade idea by #{user.username}."
      )
    end
  end
end

# Create subscriptions
users.each do |user|
  next if user.role # Skip creators

  creators = users.select { |u| u.role }
  subscribed_creators = creators.sample(2) # Each user subscribes to 2 random creators

  subscribed_creators.each do |creator|
    Subscription.create!(
      user: user, 
      trader: creator, 
      tier: ['free', 'premium'].sample, 
      price: rand(10.0..100.0), 
      duration: rand(1..12), 
      status: 'active'
    )
  end
end

puts "Seeded #{User.count} users, #{Post.count} posts, and #{Subscription.count} subscriptions."
