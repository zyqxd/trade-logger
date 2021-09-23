# frozen_string_literal: true

module Trades
  module Admin
    class TradeEntryForm < MiniForm::ActiveAdmin::BaseForm
      include MiniForm::Model

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

      def initialize(trade_entry)
        @trade_entry = trade_entry || TradeEntry.new
      end
    end
  end
end
