class IncreasePrecisionOfTradeLogs < ActiveRecord::Migration[6.1]
  def change
    change_column :trade_logs, :price, :decimal, precision: 14, scale: 6
    change_column :trade_entries, :open_price, :decimal, precision: 14, scale: 6
    change_column :trade_entries, :close_price, :decimal, precision: 14, scale: 6
    change_column :trade_entries, :paper_close_price, :decimal, precision: 14, scale: 6
    change_column :trade_entries, :paper_open_price, :decimal, precision: 14, scale: 6
  end
end
