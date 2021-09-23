class AddAmountToTrades < ActiveRecord::Migration[6.1]
  def change
    add_column(
      :trades,
      :amount,
      :decimal,
      null: false,
      default: 0,
      precision: 8,
      scale: 8,
    )

    add_column(
      :trade_entries,
      :amount,
      :decimal,
      null: false,
      default: 0,
      precision: 8,
      scale: 8,
    )
  end
end
