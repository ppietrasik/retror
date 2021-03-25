class ChangeBoardsColumnNameRequired < ActiveRecord::Migration[6.1]
  def change
    change_column_null(:boards, :name, false)
  end
end
