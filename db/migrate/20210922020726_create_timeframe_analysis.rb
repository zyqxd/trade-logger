class CreateTimeframeAnalysis < ActiveRecord::Migration[6.1]
  def change
    create_table :timeframe_analyses do |t|
      t.references :trade_entry, foreign_key: true, index: true, null: false
      t.references :timeframe, foreign_key: true, index: true, null: false

      t.string :trend
      t.string :rsi_trend
      t.decimal :rsi, precision: 8, scale: 2
      t.decimal :rsi_exponential, precision: 8, scale: 2

      t.string :stoch_rsi_trend
      t.decimal :stoch_fast, precision: 8, scale: 2
      t.decimal :stoch_slow, precision: 8, scale: 2

      t.string :bbwp_trend
      t.decimal :bbwp, precision: 8, scale: 2

      t.timestamps
    end
  end
end
