class DropTimeframeAnalysis < ActiveRecord::Migration[6.1]
  def change
    drop_table :timeframe_analyses
  end
end
