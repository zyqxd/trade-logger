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
      bip_status resource, reload: true
    end
    column :amount
    column :price
    column :post do |resource|
      bip_boolean resource, :post, url: [:admin, resource], reload: true
    end
    actions
  end

  show do
    default_main_content

    panel 'Analyses' do
      tabs do
        Timeframe.all.each do |tf|
          tab tf.code do
            render 'admin/trade_logs/analyses', timeframe: tf
          end
        end
      end
    end

    render 'admin/memos'
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
              collection: TradeLogAnalysis.bbwp_trends

      a.input :rsi
      a.input :rsi_exponential
      a.input :rsi_trend,
              as: :select,
              collection: TradeLogAnalysis.rsi_trends

      a.input :stoch_fast
      a.input :stoch_slow
      a.input :stoch_trend,
              as: :select,
              collection: TradeLogAnalysis.stoch_trends
    end

    f.has_many :memos do |m|
      m.input :title
      m.input :description, as: :text, input_html: { rows: 5 }
    end

    f.actions
  end

  member_action :cancel, method: :put do
    # TODO(DZ): We should move cancelled into separate column
    resource.update(status: resource.cancelled? ? :opened : :cancelled)
  end
end
