class CreateTrade < ActiveRecord::Migration[6.1]
  def change
    create_table :trades do |t|
      t.references :trade_entry, foreign_key: true, index: true, null: false

      t.datetime :open_time, null: true
      t.datetime :close_time, null: true
      t.decimal :open_price, null: true, precision: 8, scale: 2
      t.decimal :close_price, null: true, precision: 8, scale: 2
      t.boolean :post_open, null: false, default: false
      t.boolean :post_close, null: false, default: false

      t.timestamps
    end
  end
end
