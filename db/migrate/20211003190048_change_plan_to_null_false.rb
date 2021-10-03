class ChangePlanToNullFalse < ActiveRecord::Migration[6.1]
  def change
    change_column_null :trade_entries, :plan_id, null: false
  end
end
