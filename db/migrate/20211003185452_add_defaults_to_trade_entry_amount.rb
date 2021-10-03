class AddDefaultsToTradeEntryAmount < ActiveRecord::Migration[6.1]
  def change
    change_column_default :trade_entries, :amount, default: 0.0
    change_column_default :trade_entries, :paper_amount, default: 0.0
  end
end
