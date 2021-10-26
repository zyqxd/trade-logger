class AddScaleToAmounts < ActiveRecord::Migration[6.1]
  def change
    change_column :trade_logs, :amount, :decimal, precision: 16, scale: 10
    change_column :trade_entries, :amount, :decimal, precision: 16, scale: 10
  end
end
