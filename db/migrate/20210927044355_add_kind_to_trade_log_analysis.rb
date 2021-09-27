class AddKindToTradeLogAnalysis < ActiveRecord::Migration[6.1]
  def change
    add_column :trade_log_analyses, :kind, :string, default: 'open', null: false
  end
end
