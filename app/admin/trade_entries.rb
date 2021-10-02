# frozen_string_literal: true

ActiveAdmin.register TradeEntry, as: 'Trade Entry' do
  decorate_with Trades::Admin::TradeEntryDecorator
  MiniForm::ActiveAdmin::UseForm.call self, Trades::Admin::TradeEntryForm

  menu priority: 2

  filter :coin
  filter :kind, as: :select, collection: TradeEntry.kinds
  filter :plan, as: :select, collection: Plan.all

  scope :opened, :live_opened, default: true
  scope :closed, :live_closed
  scope :cancelled, :live_cancelled
  scope :paper

  includes :plan, :logs

  index do
    id_column
    column :coin
    column :status do |resource|
      bip_status resource, reload: true
    end
    column :kind do |resource|
      bip_kind resource, reload: true
    end
    column :open
    column :close
    column :profit
    column :profit_percentage
    column :plan do |resource|
      if resource.plan.blank?
        'N/A'
      else
        link_to resource.plan.name, admin_plan_path(resource.plan)
      end
    end
    actions
  end

  sidebar :plan, class: Rails.env, only: %i[show edit] do
    if resource.plan.blank?
      'No plan!'
    else
      attributes_table_for resource.plan do
        row :plan, &:name
        row :timeframes
        row :edge
        row :risk_management
        row :enter_strategy
        row :exit_strategy
        row :requirements
        row :notes
      end
    end
  end

  sidebar :stats, class: Rails.env, only: %i[show edit] do
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
      f.input :plan_id,
              as: :search_select,
              url: proc { admin_plans_path },
              label: 'Search Plan by Name',
              fields: %i[name],
              display_name: 'name',
              order_by: 'id_asc',
              minimum_input_length: 2

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
