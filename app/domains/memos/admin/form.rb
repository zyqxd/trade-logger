# frozen_string_literal: true

module Memos
  module Admin
    class Form < MiniForm::ActiveAdmin::BaseForm
      model(
        :memo,
        save: true,
        attributes: %i[
          memoable_id
          memoable_type
          title
          description
        ],
      )

      main_model :memo, Memo

      delegate_missing_to :memo

      def self.name
        'Memo'
      end

      def initialize(memo = nil)
        @memo = memo.presence || Memo.new
      end
    end
  end
end
