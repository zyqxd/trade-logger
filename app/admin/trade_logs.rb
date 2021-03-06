# frozen_string_literal: true

ActiveAdmin.register TradeLog, as: 'Trade Log' do
  MiniForm::ActiveAdmin::UseForm.call self, Trades::Admin::TradeLogForm

  config.clear_action_items!

  menu priority: 3

  filter :entry_id
  filter :kind, as: :select, collection: TradeLog.kinds

  scope :opened, default: true
  scope :closed

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

  sidebar :entry, class: Rails.env, only: %i[show new edit] do
    attributes_table_for resource.entry do
      row :id do |entry|
        link_to entry.id, admin_trade_entry_path(entry)
      end
      row :plan do |entry|
        link_to entry.plan.name, admin_plan_path(entry.plan)
      end
      row :status
      row :kind
      row :open_price
      row :close_price
      row :amount
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs 'Trade Log' do
      f.input :entry_id, as: :hidden
      f.input :price, as: :number
      f.input :amount, as: :number

      f.input :status,
              as: :radio,
              label: false,
              collection: TradeEntry.statuses,
              include_blank: false

      f.input :kind,
              as: :radio,
              label: false,
              collection: TradeEntry.kinds,
              include_blank: false

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

    f.actions do
      f.action :cancel,
               as: :link,
               label: 'Cancel',
               wrapper_html: { class: :cancel },
               button_html: { 'data-confirm': 'Cancel?' }

      f.action :submit, button_html: { 'data-confirm': 'Submit?' }
    end
  end

  member_action :cancel, method: :put do
    # TODO(DZ): We should move cancelled into separate column
    resource.update!(status: resource.cancelled? ? :opened : :cancelled)
  end

  member_action :toggle_kind, method: :put do
    resource.update!(kind: resource.long? ? :short : :long)
  end
end
