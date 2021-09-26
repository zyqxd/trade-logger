class AddPaperToTradeEntries < ActiveRecord::Migration[6.1]
  def change
    add_column :trade_entries, :paper, :boolean, default: false, null: false
  end
end
