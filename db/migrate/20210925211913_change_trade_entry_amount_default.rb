class ChangeTradeEntryAmountDefault < ActiveRecord::Migration[6.1]
  def change
    change_column_default :trade_entries, :amount, 1.0
  end
end
