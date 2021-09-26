class AddBasicSettingsToTradeEntry < ActiveRecord::Migration[6.1]
  def change
    add_column(
      :trade_entries,
      :margin,
      :decimal,
      null: false,
      default: 1,
      precision: 8,
      scale: 2,
    )

    add_column(
      :trade_entries,
      :maker_percentage,
      :decimal,
      null: false,
      default: 0,
      precision: 6,
      scale: 5,
    )

    add_column(
      :trade_entries,
      :taker_percentage,
      :decimal,
      null: false,
      default: 0,
      precision: 6,
      scale: 5,
    )
  end
end
