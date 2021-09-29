class AddProfitToTradeEntries < ActiveRecord::Migration[6.1]
  def change
    add_column :trade_entries, :profit, :decimal, precision: 8, scale: 2
    add_column :trade_entries, :profit_percentage, :decimal, precision: 12, scale: 8

    add_column :trade_entries, :true_profit, :decimal, precision: 8, scale: 2
    add_column :trade_entries, :true_profit_percentage, :decimal, precision: 12, scale: 8
  end
end
