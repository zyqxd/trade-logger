# frozen_string_literal: true

module Trades
  module Admin
    class TradeLogForm < MiniForm::ActiveAdmin::BaseForm
      include ActionView::Helpers::NumberHelper

      model :trade_log, save: true, attributes: %i[
        entry_id
        amount
        kind
        price
        post
        status
      ]

      main_model :trade_log, TradeLog

      def self.name
        'Trade Log'
      end

      def initialize(trade_log = nil)
        @trade_log = trade_log.presence || TradeLog.new
      end

      def price
        number_to_currency trade_log.price
      end
    end
  end
end
