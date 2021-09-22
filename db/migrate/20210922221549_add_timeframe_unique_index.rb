class AddTimeframeUniqueIndex < ActiveRecord::Migration[6.1]
  def change
    add_index :timeframes, :code, unique: true
  end
end
