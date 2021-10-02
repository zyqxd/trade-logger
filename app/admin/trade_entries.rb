# frozen_string_literal: true

ActiveAdmin.register TradeEntry, as: 'Trade Entry' do
  MiniForm::ActiveAdmin::UseForm.call self, Trades::Admin::TradeEntryForm

  menu label: 'Trade Entry'

  filter :coin
  filter :kind, as: :select, collection: TradeEntry.kinds

  scope :opened, default: true
  scope :closed
  scope :cancelled
  scope :paper

  index do
    id_column
    column :coin
    column :status do |resource|
      bip_status resource, reload: true
    end
    column :kind do |resource|
      bip_kind resource, reload: true
    end
    column :open_price
    column :close_price
    column :profit
    column :profit_percentage
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
      div class: 'panel_actions' do
        span do
          link_to(
            'Open Position',
            new_admin_trade_log_path(
              entry_id: resource.id,
              kind: resource.kind,
            ),
          )
        end
        span do
          link_to(
            'Close Position',
            new_admin_trade_log_path(
              entry_id: resource.id,
              kind: resource.short? ? :long : :short,
            ),
          )
        end
      end

      tabs do
        tab 'All', active: true do
          render 'admin/trade_entries/log', scope: :all
        end

        tab 'Opened' do
          render 'admin/trade_entries/log', scope: :opened
        end

        tab 'Closed' do
          render 'admin/trade_entries/log', scope: :closed
        end

        tab 'Cancelled' do
          render 'admin/trade_entries/log', scope: :cancelled
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
      f.input :margin
      f.input :paper, as: :boolean
    end

    f.has_many :logs do |l|
      l.input :kind,
              as: :select,
              collection: TradeLog.kinds,
              selected: l.object.kind.presence || f.object.kind

      l.input :price, as: :number
      l.input :amount, as: :number
      l.input :post, as: :boolean
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

  member_action :toggle_kind, method: :put do
    resource.update!(kind: resource.long? ? :short : :long)
  end
end
