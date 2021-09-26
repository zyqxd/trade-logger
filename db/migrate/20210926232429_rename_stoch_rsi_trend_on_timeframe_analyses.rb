class RenameStochRsiTrendOnTimeframeAnalyses < ActiveRecord::Migration[6.1]
  def change
    rename_column :timeframe_analyses, :stoch_rsi_trend, :stoch_trend
  end
end
