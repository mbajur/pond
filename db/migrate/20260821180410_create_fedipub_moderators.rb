class CreateFedipubModerators < ActiveRecord::Migration[8.1]
  def change
    create_table :fedipub_moderators do |t|
      t.references :actor, null: false, foreign_key: { to_table: :fedipub_actors }
      t.references :entity, polymorphic: true, null: false

      t.timestamps
    end
  end
end
