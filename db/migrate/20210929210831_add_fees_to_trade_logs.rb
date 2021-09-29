class AddFeesToTradeLogs < ActiveRecord::Migration[6.1]
  def change
    add_column :trade_logs, :fee, :decimal, null: false, precision: 8, scale: 2, default: 0
  end
end
