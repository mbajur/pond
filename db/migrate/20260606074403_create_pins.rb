class CreatePins < ActiveRecord::Migration[8.1]
  def change
    create_table :pins do |t|
      t.references :pinable, polymorphic: true, null: false
      t.references :collection, null: true, foreign_key: { to_table: :collections }

      t.timestamps
    end
  end
end
