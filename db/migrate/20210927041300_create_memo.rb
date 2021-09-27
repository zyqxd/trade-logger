class CreateMemo < ActiveRecord::Migration[6.1]
  def change
    create_table :memos do |t|
      t.references :memoable, polymorphic: true, index: true
      t.string :title
      t.text :description
      t.timestamps
    end
  end
end
