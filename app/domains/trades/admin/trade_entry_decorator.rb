# frozen_string_literal: true

module Trades
  module Admin
    class TradeEntryDecorator
      include ActionView::Helpers::NumberHelper

      attr_reader :trade_entry

      delegate_missing_to :trade_entry

      # NOTE(DZ): Helps url helpers to find the correct link
      def to_param
        trade_entry.id
      end

      def initialize(trade_entry)
        @trade_entry = trade_entry || TradeEntry.new
      end

      def paper_open_price
        number_to_accounting trade_entry.paper_open_price
      end

      def paper_close_price
        number_to_accounting trade_entry.paper_close_price
      end

      def open_price
        number_to_accounting trade_entry.open_price
      end

      def close_price
        number_to_accounting trade_entry.close_price
      end

      def position
        number_to_accounting trade.position
      end

      def profit
        number_to_accounting trade_entry.profit
      end

      def profit_percentage
        return 'N/A' if trade_entry.profit_percentage.blank?

        number_to_percentage trade_entry.profit_percentage, precision: 2
      end

      def true_profit
        number_to_accounting trade_entry.true_profit
      end

      def true_profit_percentage
        return 'N/A' if trade_entry.true_profit_percentage.blank?

        number_to_percentage trade_entry.true_profit_percentage, precision: 2
      end

      private

      def number_to_accounting(number)
        return 'N/A' if number.blank? || number.nan?

        number_to_currency number, negative_format: '(%u%n)'
      end
    end
  end
end
