# frozen_string_literal: true

module Trades
  module Admin
    class PlanForm < MiniForm::ActiveAdmin::BaseForm
      model :plan, save: true, attributes: %i[
        edge
        enter_strategy
        exit_strategy
        margin
        name
        notes
        requirements
        risk_management
        timeframes
      ]

      main_model :plan, Plan

      delegate_missing_to :plan

      def self.name
        'Plan'
      end

      def initialize(plan = nil)
        @plan = plan.presence || Plan.new
      end
    end
  end
end
