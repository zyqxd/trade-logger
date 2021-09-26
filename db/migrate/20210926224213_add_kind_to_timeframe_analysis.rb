class AddKindToTimeframeAnalysis < ActiveRecord::Migration[6.1]
  def change
    add_column :timeframe_analyses, :kind, :string, default: 'open', null: false
  end
end
