# frozen_string_literal: true

ActiveAdmin.register TradeLogAnalysis, as: 'TradeLog Analysis' do
  permit_params(*TradeLogAnalysis.column_names)

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs 'Trade Log' do
      f.input :trade_log
      f.input :timeframe,
              as: :select,
              collection: Timeframe.pluck(:code, :id)

      f.input :kind, as: :select, collection: TradeLogAnalysis.kinds
      f.input :trend, as: :select, collection: TradeLogAnalysis.trends

      f.input :bbwp
      f.input :bbwp_exponential
      f.input :bbwp_trend,
              as: :select,
              collection: TradeLogAnalysis.bbwp_trends

      f.input :rsi
      f.input :rsi_exponential
      f.input :rsi_trend,
              as: :select,
              collection: TradeLogAnalysis.rsi_trends

      f.input :stoch_fast
      f.input :stoch_slow
      f.input :stoch_trend,
              as: :select,
              collection: TradeLogAnalysis.stoch_trends
    end

    f.actions
  end
end
