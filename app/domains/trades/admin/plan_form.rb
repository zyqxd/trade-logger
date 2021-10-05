# frozen_string_literal: true

module Trades
  module Admin
    class PlanForm
      model :plan, save: true, attributes: *Plan.column_names

      def self.name
        'Plan'
      end

      def initialize(plan = nil)
        @plan = plan.presence || Plan.new
      end
    end
  end
end