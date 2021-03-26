class CreateLists < ActiveRecord::Migration[6.1]
  def change
    create_table :lists, id: :uuid do |t|
      t.references :board, null: false, foreign_key: true, type: :uuid
      t.string :name, null: false

      t.timestamps
    end
  end
end
