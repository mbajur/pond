class CreateLikes < ActiveRecord::Migration[8.1]
  def change
    create_table :likes do |t|
      t.references :likeable, polymorphic: true, null: false
      t.references :fedipub_actor, null: false, foreign_key: { to_table: :fedipub_actors }

      t.timestamps
    end
  end
end
