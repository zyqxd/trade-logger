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
        post_close
        post_open
        status
      ]

      main_model :trade_entry, TradeEntry

      def self.name
        'Trade Entry'
      end

      def initialize(trade_entry)
        @trade_entry = trade_entry || TradeEntry.new
      end

      def open_price
        number_to_currency trade_entry.open_price
      end

      def close_price
        number_to_currency trade_entry.close_price
      end

      def pnl
        return 'N/A' if !trade_entry.close_price || !trade_entry.open_price

        number_to_currency trade_entry.close_price - trade_entry.open_price
      end
    end
  end
end
