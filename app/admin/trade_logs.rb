# frozen_string_literal: true

ActiveAdmin.register TradeLog, as: 'Trade Log' do
  MiniForm::ActiveAdmin::UseForm.call self, Trades::Admin::TradeLogForm

  menu label: 'Log', parent: 'Trade'

  actions :all, except: :show

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
