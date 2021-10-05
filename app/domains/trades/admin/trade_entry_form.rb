# frozen_string_literal: true

module Trades
  module Admin
    class TradeEntryForm < MiniForm::ActiveAdmin::BaseForm
      model(
        :trade_entry,
        save: true,
        attributes: %i[
          plan_id
          coin
          kind
          paper
          margin
          status
        ],
        nested_attributes: {
          logs: %i[
            id
            kind
            price
            amount
            post
          ],
          analyses: %i[
            id
            bbwp
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
          ],
        },
      )

      main_model :trade_entry, TradeEntry

      delegate_missing_to :trade_entry

      def self.name
        'Trade Entry'
      end

      def initialize(trade_entry = nil)
        @trade_entry = trade_entry.presence || TradeEntry.new
      end

      def margin
        return margin if trade_entry.persisted? || trade_entry.plan.blank?

        trade_entry.plan.margin
      end
    end
  end
end
