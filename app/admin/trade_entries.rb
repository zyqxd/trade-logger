# frozen_string_literal: true

ActiveAdmin.register TradeEntry, as: 'Trade Entry' do
  MiniForm::ActiveAdmin::UseForm.call self, Trades::Admin::TradeEntryForm

  menu label: 'Entry', parent: 'Trade'

  filter :coin
  filter :kind, as: :select, collection: TradeEntry.kinds

  scope :opened
  scope :filled
  scope :closed
  scope :cancelled

  index do
    id_column
    column :coin
    column :status do |resource|
      bip_status resource, reload: true
    end
    column :stopped do |resource|
      bip_boolean resource, :stopped, url: [:admin, resource], reload: true
    end
    column :kind
    column :open_price
    column :close_price
    column :profit
    column :paper
    actions
  end

  sidebar :stats, only: %i[show] do
    attributes_table_for resource do
      row :status do
        bip_status resource, reload: true
      end
      row :profit
      row :true_profit
      row :profit_percentage
      row :true_profit_percentage
    end
  end

  show do
    default_main_content

    panel 'Logs' do
      div do
        link_to 'New', new_admin_trade_log_path
      end

      tabs do
        tab 'Opened', active: true do
          render 'admin/trade_entries/log', scope: :opened
        end

        tab 'Filled' do
          render 'admin/trade_entries/log', scope: :filled
        end

        tab 'Cancelled' do
          render 'admin/trade_entries/log', scope: :cancelled
        end

        tab 'Closed' do
          render 'admin/trade_entries/log', scope: :closed
        end
      end
    end

    panel 'Analyses' do
      div do
        link_to 'New', new_admin_timeframe_analysis_path
      end

      table_for(
        resource.analyses.includes(:timeframe).order(created_at: :desc),
      ) do
        column :id
        column :timeframe
        column :kind
        column :trend
        column :actions do |analysis|
          link_to 'View', admin_timeframe_analysis_path(analysis)
        end
      end
    end

    render 'admin/memos'

    render 'admin/audits'
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs 'Trade Entry' do
      f.input :status, as: :select, collection: TradeEntry.statuses
      f.input :coin, as: :select, collection: TradeEntry.coins
      f.input :kind, as: :select, collection: TradeEntry.kinds

      f.input :open_price, as: :number
      f.input :close_price, as: :number
      f.input :amount, as: :number

      f.input :open_time, as: :datetime_picker
      f.input :post_open, as: :boolean

      f.input :close_time, as: :datetime_picker
      f.input :post_close, as: :boolean
      f.input :paper, as: :boolean
    end

    f.has_many :analyses do |a|
      a.input :timeframe,
              as: :select,
              collection: Timeframe.pluck(:code, :id)

      a.input :kind, as: :select, collection: TimeframeAnalysis.kinds
      a.input :trend, as: :select, collection: TimeframeAnalysis.trends

      a.input :bbwp
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
