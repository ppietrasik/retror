class AddPositionToList < ActiveRecord::Migration[6.1]
  def change
    add_column :lists, :position, :integer, null: false
  end
end
