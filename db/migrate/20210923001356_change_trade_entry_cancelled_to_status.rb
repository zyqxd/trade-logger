class ChangeTradeEntryCancelledToStatus < ActiveRecord::Migration[6.1]
  def change
    add_column :trade_entries, :status, :string, null: false, default: 'opened'
    remove_column :trade_entries, :cancelled, :boolean, default: false
  end
end
