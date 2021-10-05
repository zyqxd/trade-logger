class AddMarginToPlan < ActiveRecord::Migration[6.1]
  def change
    add_column :plans, :margin, :decimal, precision: 8, scale: 4, default: 1, null: false
  end
end
