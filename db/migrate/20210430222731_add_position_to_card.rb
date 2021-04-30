class AddPositionToCard < ActiveRecord::Migration[6.1]
  def change
    add_column :cards, :position, :integer, null: false
  end
end
