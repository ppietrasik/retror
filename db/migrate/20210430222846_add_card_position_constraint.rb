class AddCardPositionConstraint < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL
      ALTER TABLE cards
        ADD CONSTRAINT cards_position UNIQUE (list_id, position) DEFERRABLE INITIALLY DEFERRED;
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE cards
        DROP CONSTRAINT cards_position;
    SQL
  end
end
