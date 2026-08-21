# frozen_string_literal: true

class AssignFedipubActorsToFollows < ActiveRecord::Migration[8.1]
  def up
    Follow.find_each do |follow|
      follow.fedipub_actor = follow.actor.fedipub_actor
      follow.save!
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
