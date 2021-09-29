class RemoveUnusedTradeEntriesColumns < ActiveRecord::Migration[6.1]
  def change
    remove_column :trade_entries, :open_time
    remove_column :trade_entries, :close_time
    remove_column :trade_entries, :post_open
    remove_column :trade_entries, :post_close
    remove_column :trade_entries, :stopped
  end
end
