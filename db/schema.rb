# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171020204514) do

  create_table "articles", force: :cascade do |t|
    t.string   "title"
    t.string   "content"
    t.string   "invoice"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chats", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "contact_messages", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "donations", force: :cascade do |t|
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.float    "value"
    t.integer  "user_id"
    t.decimal  "pending"
    t.integer  "status",       default: 0
    t.boolean  "completed",    default: false
    t.datetime "confirmed_at", default: '2017-10-12 05:04:38'
  end

  create_table "messages", force: :cascade do |t|
    t.text     "body"
    t.integer  "user_id"
    t.boolean  "read",            default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "chat_id"
    t.boolean  "sender_readed",   default: false
    t.boolean  "receiver_readed", default: false
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.boolean  "read"
    t.integer  "message_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "owner_id"
    t.decimal  "value"
    t.decimal  "transaction_value"
    t.index ["message_id"], name: "index_notifications_on_message_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "requests", force: :cascade do |t|
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "user_id"
    t.decimal  "value"
    t.integer  "status",     default: 0
    t.decimal  "pending"
    t.integer  "requested",  default: 0
    t.boolean  "completed",  default: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer  "value"
    t.integer  "donation_id"
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.boolean  "status",      default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "request_id"
    t.string   "invoice"
    t.integer  "completed",   default: 0
    t.index ["donation_id"], name: "index_transactions_on_donation_id"
    t.index ["request_id"], name: "index_transactions_on_request_id"
  end

  create_table "transfers", force: :cascade do |t|
    t.decimal  "value"
    t.integer  "status",      default: 0
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "donation_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "name"
    t.string   "btc"
    t.string   "phone"
    t.string   "country"
    t.float    "saldo"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",        default: 0,     null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.boolean  "admin",                  default: false
    t.integer  "parent_id"
    t.string   "ancestry"
    t.integer  "ancestry_depth",         default: 0
    t.decimal  "level_one_amount",       default: "0.0"
    t.decimal  "level_two_amount",       default: "0.0"
    t.decimal  "level_three_amount",     default: "0.0"
    t.decimal  "level_four_amount",      default: "0.0"
    t.decimal  "level_five_amount",      default: "0.0"
    t.decimal  "level_six_amount",       default: "0.0"
    t.boolean  "blocked"
    t.string   "referral_email",         default: " "
    t.index ["ancestry"], name: "index_users_on_ancestry"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
  end

end
