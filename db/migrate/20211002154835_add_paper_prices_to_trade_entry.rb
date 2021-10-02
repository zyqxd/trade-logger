class AddPaperPricesToTradeEntry < ActiveRecord::Migration[6.1]
  def change
    add_column :trade_entries, :paper_open_price, :decimal, precision: 8, scale: 2
    add_column :trade_entries, :paper_close_price, :decimal, precision: 8, scale: 2
    add_column :trade_entries, :paper_amount, :decimal, precision: 12, scale: 8
  end
end
