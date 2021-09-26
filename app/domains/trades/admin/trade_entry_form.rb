# frozen_string_literal: true

module Trades
  module Admin
    class TradeEntryForm < MiniForm::ActiveAdmin::BaseForm
      include ActionView::Helpers::NumberHelper

      model :trade_entry, save: true, attributes: %i[
        amount
        close_price
        close_time
        coin
        kind
        open_price
        open_time
        paper
        post_close
        post_open
        status
      ]

      main_model :trade_entry, TradeEntry

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
