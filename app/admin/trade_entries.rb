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
      bip_tag(
        resource,
        :status,
        as: :select,
        url: [:admin, resource],
        collection: TradeEntry.statuses,
        reload: true,
      )
    end
    column :stopped do |resource|
      bip_status_tag resource, :stopped, url: [:admin, resource], reload: true
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
        bip_tag(
          resource,
          :status,
          as: :select,
          url: [:admin, resource],
          collection: TradeEntry.statuses,
          reload: true,
        )
      end
      row :profit
      row :true_profit
      row :profit_percentage
      row :true_profit_percentage
    end
  end

  show do
    default_main_content

    panel 'Log' do
      table_for resource.logs.order(close_time: :desc, updated_at: :desc) do
        column :id
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
        column :kind
        column :price
        column :amount
      end
    end
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

    f.actions
  end
end
