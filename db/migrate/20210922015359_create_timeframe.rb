class CreateTimeframe < ActiveRecord::Migration[6.1]
  def change
    create_table :timeframes do |t|
      t.string :code, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
