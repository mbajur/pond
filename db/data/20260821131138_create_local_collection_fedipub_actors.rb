# frozen_string_literal: true

class CreateLocalCollectionFedipubActors < ActiveRecord::Migration[8.1]
  def up
    Collection.find_each do |collection|
      collection.send(:create_fedipub_actor) unless collection.fedipub_actor
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
