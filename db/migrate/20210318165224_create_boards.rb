class CreateBoards < ActiveRecord::Migration[6.1]
  def change
    create_table :boards, id: :uuid do |t|
      t.string :name, null: true

      t.timestamps
    end
  end
end
