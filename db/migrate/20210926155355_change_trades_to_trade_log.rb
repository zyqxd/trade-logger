class ChangeTradesToTradeLog < ActiveRecord::Migration[6.1]
  def change
    # drop_table :trades

    create_table :trade_logs do |t|
      t.references(
        :entry,
        foreign_key: { to_table: :trade_entries },
        index: true,
      )

      t.string :status, null: false, default: 'opened'
      t.string :kind, null: false, default: 'long'
      t.boolean :post, null: false, default: false
      t.decimal :price, null: false, precision: 12, scale: 2
      t.decimal :amount, null: false, precision: 12, scale: 8
      t.datetime :close_time, null: true

      t.timestamps
    end
  end
end
