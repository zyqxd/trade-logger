class AddActiveToPlans < ActiveRecord::Migration[6.1]
  def change
    add_column :plans, :active, :boolean, default: true, null: false
  end
end
