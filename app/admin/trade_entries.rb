# frozen_string_literal: true

ActiveAdmin.register TradeEntry, as: 'TradeEntry' do
  MiniForm::ActiveAdmin::UseForm.call self, Trades::Admin::TradeEntryForm

  menu label: 'Trade Entry', parent: 'Trade'

  filter :coin
  filter :kind

  scope :opened
  scope :filled
  scope :closed
  scope :cancelled

  index do
    id_column
    column :coin
    column :kind
    column :open_price
    column :close_price
    actions
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
    end

    f.actions
  end
end
