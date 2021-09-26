# frozen_string_literal: true

ActiveAdmin.register TimeframeAnalysis, as: 'Timeframe Analysis' do
  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs 'Trade Log' do
      f.input :entry
      f.input :status, as: :select, collection: TradeLog.statuses
      f.input :kind, as: :select, collection: TradeLog.kinds

      f.input :price, as: :number
      f.input :amount, as: :number
      f.input :post, as: :boolean
    end

    f.actions
  end
end
