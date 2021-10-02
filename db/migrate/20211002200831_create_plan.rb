class CreatePlan < ActiveRecord::Migration[6.1]
  def change
    create_table :plans do |t|
      t.string :name, null: false
      t.text :timeframes
      t.text :edge
      t.text :risk_management
      t.text :enter_strategy
      t.text :exit_strategy
      t.text :requirements
      t.text :notes
      t.integer :trade_entries_count, default: 0, null: false

      t.timestamps
    end

    add_reference :trade_entries, :plan, foreign_key: true, index: true
  end
end
