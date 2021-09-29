# frozen_string_literal: true

module Trades
  module Admin
    class TradeEntryForm < MiniForm::ActiveAdmin::BaseForm
      include ActionView::Helpers::NumberHelper

      model(
        :trade_entry,
        save: true,
        attributes: %i[
          coin
          kind
          paper
          status
        ],
        nested_attributes: {
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

      delegate(
        :own_and_associated_audits,
        *TradeEntry.reflect_on_all_associations.map(&:name),
        to: :trade_entry,
      )

      def self.name
        'Trade Entry'
      end

      def initialize(trade_entry = nil)
        @trade_entry = trade_entry.presence || TradeEntry.new
      end

      def open_price
        number_to_currency trade_entry.open_price
      end

      def close_price
        number_to_currency trade_entry.close_price
      end

      def position
        number_to_currency trade.position
      end

      def profit
        return 'N/A' if trade_entry.profit.blank?

        number_to_currency trade_entry.profit
      end

      def profit_percentage
        return 'N/A' if trade_entry.profit_percentage.blank?

        number_to_percentage trade_entry.profit_percentage
      end

      def true_profit
        return 'N/A' if trade_entry.true_profit.blank?

        number_to_currency trade_entry.true_profit
      end

      def true_profit_percentage
        return 'N/A' if trade_entry.true_profit_percentage.blank?

        number_to_percentage trade_entry.true_profit_percentage
      end
    end
  end
end
