# frozen_string_literal: true

class CreateFedipubModerators < ActiveRecord::Migration[8.1]
  def up
    Collection.find_each do |collection|
      Fedipub::Moderator.find_or_create_by!(actor: collection.user.fedipub_actor, entity: collection)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
