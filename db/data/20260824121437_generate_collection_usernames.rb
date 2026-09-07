# frozen_string_literal: true

class GenerateCollectionUsernames < ActiveRecord::Migration[8.1]
  def up
    Collection.find_each do |collection|
      collection.save!
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
