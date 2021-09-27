# frozen_string_literal: true

ActiveAdmin.register TradeLog, as: 'Trade Log' do
  MiniForm::ActiveAdmin::UseForm.call self, Trades::Admin::TradeLogForm

  menu label: 'Log', parent: 'Trade'

  filter :entry_id
  filter :kind, as: :select, collection: TradeLog.kinds

  scope :opened
  scope :closed
  scope :cancelled

  index do
    id_column
    column :entry
    column :kind
    column :status do |resource|
      bip_tag(
        resource,
        :status,
        as: :select,
        url: [:admin, resource],
        collection: TradeLog.statuses,
        reload: true,
      )
    end
    column :amount
    column :price
    actions
  end

  show do
    default_main_content

    panel 'Analyses' do
      div do
        link_to 'New', new_admin_trade_log_analysis_path
      end

      table_for resource.analyses.includes(:timeframe).order(created_at: :desc) do
        column :id
        column :timeframe
        column :kind
        column :trend
        column :actions do
          link_to 'View', admin_timeframe_analysis_path(resource)
        end
      end
    end
  end

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

    f.has_many :analyses do |a|
      a.input :timeframe,
              as: :select,
              collection: Timeframe.pluck(:code, :id)

      a.input :kind, as: :select, collection: TradeLogAnalysis.kinds
      a.input :trend, as: :select, collection: TradeLogAnalysis.trends

      a.input :bbwp
      a.input :bbwp_exponential
      a.input :bbwp_trend,
              as: :select,
              collection: TimeframeAnalysis.bbwp_trends

      a.input :rsi
      a.input :rsi_exponential
      a.input :rsi_trend,
              as: :select,
              collection: TimeframeAnalysis.rsi_trends

      a.input :stoch_fast
      a.input :stoch_slow
      a.input :stoch_trend,
              as: :select,
              collection: TimeframeAnalysis.stoch_trends
    end

    f.actions
  end
end
