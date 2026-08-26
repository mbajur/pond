class RemoveActorFromFollows < ActiveRecord::Migration[8.1]
  def change
    remove_reference :follows, :actor, foreign_key: { to_table: :users }
  end
end
