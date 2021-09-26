class AddStoppedToTradeEntry < ActiveRecord::Migration[6.1]
  def change
    add_column :trade_entries, :stopped, :boolean, null: false, default: false
  end
end
