# frozen_string_literal: true

ActiveAdmin.register TimeframeAnalysis, as: 'Timeframe Analysis' do
  permit_params(*TimeframeAnalysis.column_names)

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs 'Trade Log' do
      f.input :trade_entry
      f.input :timeframe,
              as: :select,
              collection: Timeframe.pluck(:code, :id)

      f.input :kind, as: :select, collection: TimeframeAnalysis.kinds
      f.input :trend, as: :select, collection: TimeframeAnalysis.trends

      f.input :bbwp
      f.input :bbwp_trend,
              as: :select,
              collection: TimeframeAnalysis.bbwp_trends

      f.input :rsi
      f.input :rsi_exponential
      f.input :rsi_trend,
              as: :select,
              collection: TimeframeAnalysis.rsi_trends

      f.input :stoch_fast
      f.input :stoch_slow
      f.input :stoch_trend,
              as: :select,
              collection: TimeframeAnalysis.stoch_trends
    end

    f.actions
  end
end
