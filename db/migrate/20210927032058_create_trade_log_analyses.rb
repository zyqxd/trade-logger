class CreateTradeLogAnalyses < ActiveRecord::Migration[6.1]
  def change
    create_table :trade_log_analyses do |t|
      t.references :trade_log, foreign_key: true, index: true, null: false
      t.references :timeframe, foreign_key: true, index: true, null: false

      t.string :trend
      t.string :rsi_trend
      t.decimal :rsi, precision: 8, scale: 4
      t.decimal :rsi_exponential, precision: 8, scale: 4

      t.string :stoch_trend
      t.decimal :stoch_fast, precision: 8, scale: 4
      t.decimal :stoch_slow, precision: 8, scale: 4

      t.string :bbwp_trend
      t.decimal :bbwp, precision: 8, scale: 2
      t.decimal :bbwp_exponential, precision: 8, scale: 4

      t.timestamps
    end
  end
end
