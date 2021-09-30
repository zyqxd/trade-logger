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

ActiveRecord::Schema.define(version: 2021_09_30_000045) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.jsonb "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "memos", force: :cascade do |t|
    t.string "memoable_type"
    t.bigint "memoable_id"
    t.string "title"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["memoable_type", "memoable_id"], name: "index_memos_on_memoable"
  end

  create_table "timeframe_analyses", force: :cascade do |t|
    t.bigint "trade_entry_id", null: false
    t.bigint "timeframe_id", null: false
    t.string "trend"
    t.string "rsi_trend"
    t.decimal "rsi", precision: 8, scale: 2
    t.decimal "rsi_exponential", precision: 8, scale: 2
    t.string "stoch_trend"
    t.decimal "stoch_fast", precision: 8, scale: 2
    t.decimal "stoch_slow", precision: 8, scale: 2
    t.string "bbwp_trend"
    t.decimal "bbwp", precision: 8, scale: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "kind", default: "open", null: false
    t.index ["timeframe_id"], name: "index_timeframe_analyses_on_timeframe_id"
    t.index ["trade_entry_id"], name: "index_timeframe_analyses_on_trade_entry_id"
  end

  create_table "timeframes", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_timeframes_on_code", unique: true
  end

  create_table "trade_entries", force: :cascade do |t|
    t.string "coin", default: "btcusdt", null: false
    t.string "kind", default: "long", null: false
    t.decimal "open_price", precision: 8, scale: 2
    t.decimal "close_price", precision: 8, scale: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "amount", precision: 12, scale: 8, default: "1.0", null: false
    t.string "status", default: "opened", null: false
    t.decimal "margin", precision: 8, scale: 2, default: "1.0", null: false
    t.boolean "paper", default: false, null: false
    t.decimal "profit", precision: 8, scale: 2
    t.decimal "profit_percentage", precision: 12, scale: 8
    t.decimal "true_profit", precision: 8, scale: 2
    t.decimal "true_profit_percentage", precision: 12, scale: 8
  end

  create_table "trade_log_analyses", force: :cascade do |t|
    t.bigint "trade_log_id", null: false
    t.bigint "timeframe_id", null: false
    t.string "trend"
    t.string "rsi_trend"
    t.decimal "rsi", precision: 8, scale: 4
    t.decimal "rsi_exponential", precision: 8, scale: 4
    t.string "stoch_trend"
    t.decimal "stoch_fast", precision: 8, scale: 4
    t.decimal "stoch_slow", precision: 8, scale: 4
    t.string "bbwp_trend"
    t.decimal "bbwp", precision: 8, scale: 2
    t.decimal "bbwp_exponential", precision: 8, scale: 4
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "kind", default: "open", null: false
    t.index ["timeframe_id"], name: "index_trade_log_analyses_on_timeframe_id"
    t.index ["trade_log_id"], name: "index_trade_log_analyses_on_trade_log_id"
  end

  create_table "trade_logs", force: :cascade do |t|
    t.bigint "entry_id"
    t.string "status", default: "opened", null: false
    t.string "kind", default: "long", null: false
    t.boolean "post", default: false, null: false
    t.decimal "price", precision: 12, scale: 2, null: false
    t.decimal "amount", precision: 12, scale: 8, null: false
    t.datetime "close_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "fee", precision: 8, scale: 2, default: "0.0", null: false
    t.index ["entry_id"], name: "index_trade_logs_on_entry_id"
  end

  add_foreign_key "timeframe_analyses", "timeframes"
  add_foreign_key "timeframe_analyses", "trade_entries"
  add_foreign_key "trade_log_analyses", "timeframes"
  add_foreign_key "trade_log_analyses", "trade_logs"
  add_foreign_key "trade_logs", "trade_entries", column: "entry_id"
end
