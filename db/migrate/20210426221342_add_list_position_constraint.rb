class AddListPositionConstraint < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL
      ALTER TABLE lists
        ADD CONSTRAINT lists_position UNIQUE (board_id, position) DEFERRABLE INITIALLY DEFERRED;
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE lists
        DROP CONSTRAINT lists_position;
    SQL
  end
end
