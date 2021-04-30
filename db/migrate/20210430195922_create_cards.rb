class CreateCards < ActiveRecord::Migration[6.1]
  def change
    create_table :cards, id: :uuid do |t|
      t.references :list, null: false, foreign_key: true, type: :uuid
      t.text :note, null: false

      t.timestamps
    end
  end
end
