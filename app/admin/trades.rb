# frozen_string_literal: true

ActiveAdmin.register Trade, as: 'Trade' do
  menu label: 'Trade', parent: 'Trade'

  filter :trade_entry_id

  index do
    id_column
    column :trade_entry
    column :open_price
    column :close_price
  end
end
