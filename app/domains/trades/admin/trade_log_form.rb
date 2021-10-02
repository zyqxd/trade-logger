# frozen_string_literal: true

module Trades
  module Admin
    class TradeLogForm < MiniForm::ActiveAdmin::BaseForm
      include ActionView::Helpers::NumberHelper

      model(
        :trade_log,
        save: true,
        attributes: %i[
          entry_id
          amount
          kind
          price
          post
          status
        ],
        nested_attributes: {
          analyses: %i[
            id
            bbwp
            bbwp_exponential
            bbwp_trend
            kind
            rsi
            rsi_exponential
            rsi_trend
            stoch_fast
            stoch_slow
            stoch_trend
            trend
            timeframe_id
            _destroy
          ],
          memos: %i[
            id
            title
            description
            _destroy
          ],
        },
      )

      main_model :trade_log, TradeLog

      delegate_missing_to :trade_log

      def self.name
        'Trade Log'
      end

      def initialize(trade_log = nil)
        @trade_log = trade_log.presence || TradeLog.new
      end
    end
  end
end
