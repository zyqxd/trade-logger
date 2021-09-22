# frozen_string_literal: true

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

ActiveRecord::Schema.define(version: 20_210_922_221_549) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'timeframe_analyses', force: :cascade do |t|
    t.bigint 'trade_entry_id', null: false
    t.bigint 'timeframe_id', null: false
    t.string 'trend'
    t.string 'rsi_trend'
    t.decimal 'rsi', precision: 8, scale: 2
    t.decimal 'rsi_exponential', precision: 8, scale: 2
    t.string 'stoch_rsi_trend'
    t.decimal 'stoch_fast', precision: 8, scale: 2
    t.decimal 'stoch_slow', precision: 8, scale: 2
    t.string 'bbwp_trend'
    t.decimal 'bbwp', precision: 8, scale: 2
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['timeframe_id'], name: 'index_timeframe_analyses_on_timeframe_id'
    t.index ['trade_entry_id'],
            name: 'index_timeframe_analyses_on_trade_entry_id'
  end

  create_table 'timeframes', force: :cascade do |t|
    t.string 'code', null: false
    t.string 'name', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['code'], name: 'index_timeframes_on_code', unique: true
  end

  create_table 'trade_entries', force: :cascade do |t|
    t.string 'coin', default: 'btcusdt', null: false
    t.string 'kind', default: 'long', null: false
    t.boolean 'cancelled', default: false, null: false
    t.datetime 'open_time'
    t.datetime 'close_time'
    t.decimal 'open_price', precision: 8, scale: 2
    t.decimal 'close_price', precision: 8, scale: 2
    t.boolean 'post_open', default: false, null: false
    t.boolean 'post_close', default: false, null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'trades', force: :cascade do |t|
    t.bigint 'trade_entry_id', null: false
    t.datetime 'open_time'
    t.datetime 'close_time'
    t.decimal 'open_price', precision: 8, scale: 2
    t.decimal 'close_price', precision: 8, scale: 2
    t.boolean 'post_open', default: false, null: false
    t.boolean 'post_close', default: false, null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['trade_entry_id'], name: 'index_trades_on_trade_entry_id'
  end

  add_foreign_key 'timeframe_analyses', 'timeframes'
  add_foreign_key 'timeframe_analyses', 'trade_entries'
  add_foreign_key 'trades', 'trade_entries'
end
