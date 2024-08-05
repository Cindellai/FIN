# lib/tasks/dev.rake

namespace :db do
  desc "Generate sample data"
  task sample_data: :environment do
    p "Creating sample data"

    if Rails.env.development?
      Comment.delete_all
      Post.delete_all
      Trade.delete_all
      Subscription.delete_all
      User.delete_all
    end

    # Create Users
    traders = []
    students = []

    5.times do
      traders << User.create!(
        email: Faker::Internet.email,
        password: 'password',
        username: Faker::Internet.username,
        role: true
      )
    end

    7.times do
      students << User.create!(
        email: Faker::Internet.email,
        password: 'password',
        username: Faker::Internet.username,
        role: false
      )
    end

    p "Created #{User.count} users."

    # Create Subscriptions
    students.each do |student|
      traders.each do |trader|
        Subscription.create!(
          user: student,
          trader: trader,
          tier: ['free', 'premium'].sample,
          price: Faker::Commerce.price(range: 5.0..100.0),
          duration: [1, 3, 6, 12].sample,
          status: ['active', 'inactive'].sample
        )
      end
    end

    p "Created #{Subscription.count} subscriptions."

    # Create Trades
    traders.each do |trader|
      5.times do
        Trade.create!(
          poster: trader,
          stock_name: Faker::Company.name,
          executed_at: Faker::Time.between(from: 2.days.ago, to: Time.now),
          performance: Faker::Number.decimal(l_digits: 2),
          buy_or_sell: ['buy', 'sell'].sample,
          quantity: Faker::Number.between(from: 1, to: 100),
          price: Faker::Number.decimal(l_digits: 2),
          description: Faker::Lorem.sentence
        )
      end
    end

    p "Created #{Trade.count} trades."

    # Create Posts
    traders.each do |trader|
      3.times do
        Post.create!(
          title: Faker::Lorem.sentence,
          content_type: ['article', 'video', 'trade_idea'].sample,
          url: Faker::Internet.url,
          body: Faker::Lorem.paragraph,
          posted_by: trader
        )
      end
    end

    p "Created #{Post.count} posts."

    # Create Comments
    students.each do |student|
      Trade.all.sample(3).each do |trade|
        Comment.create!(
          user: student,
          trade: trade,
          body: Faker::Lorem.sentence
        )
      end

      Post.all.sample(3).each do |post|
        Comment.create!(
          user: student,
          post: post,
          body: Faker::Lorem.sentence
        )
      end
    end

    p "Created #{Comment.count} comments."
  end
end
