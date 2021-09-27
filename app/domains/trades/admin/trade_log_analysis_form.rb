# frozen_string_literal: true

module Trades
  module Admin
    class TradeLogAnalysisForm
      include ActionView::Helpers::NumberHelper

      # model(
      #   :trade_log_analyses
      #   save: true,
      #   attributes: %i[
      #     #  bbwp             :decimal(8, 2)
      #     #  bbwp_exponential :decimal(8, 4)
      #     #  bbwp_trend       :string
      #     #  rsi              :decimal(8, 4)
      #     #  rsi_exponential  :decimal(8, 4)
      #     #  rsi_trend        :string
      #     #  stoch_fast       :decimal(8, 4)
      #     #  stoch_slow       :decimal(8, 4)
      #     #  stoch_trend      :string
      #     #  trend            :string
      #     #  created_at       :datetime         not null
      #     #  updated_at       :datetime         not null
      #     #  timeframe_id     :bigint           not null
      #     #  trade_log_id     :bigint           not null
      #   ]
      # )
    end
  end
end
