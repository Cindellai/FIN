# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_08_03_233843) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "trade_id"
    t.bigint "post_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["trade_id"], name: "index_comments_on_trade_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.string "content_type"
    t.string "url"
    t.text "body"
    t.bigint "posted_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "post_type"
    t.index ["posted_by_id"], name: "index_posts_on_posted_by_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "trader_id", null: false
    t.string "tier"
    t.decimal "price", precision: 10, scale: 2
    t.integer "duration"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trader_id"], name: "index_subscriptions_on_trader_id"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "trades", force: :cascade do |t|
    t.bigint "poster_id", null: false
    t.string "stock_name"
    t.datetime "executed_at"
    t.float "performance"
    t.string "buy_or_sell"
    t.integer "quantity"
    t.decimal "price", precision: 10, scale: 2
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "post_id"
    t.index ["poster_id"], name: "index_trades_on_poster_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "username", default: "", null: false
    t.string "profile_picture"
    t.text "bio"
    t.boolean "role", default: false
    t.float "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "comments", "trades"
  add_foreign_key "comments", "users"
  add_foreign_key "posts", "users", column: "posted_by_id"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "subscriptions", "users", column: "trader_id"
  add_foreign_key "trades", "users", column: "poster_id"
end
