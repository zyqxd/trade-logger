class DropFeesFromTradeEntry < ActiveRecord::Migration[6.1]
  def change
    remove_column :trade_entries, :maker_percentage
    remove_column :trade_entries, :taker_percentage
  end
end
