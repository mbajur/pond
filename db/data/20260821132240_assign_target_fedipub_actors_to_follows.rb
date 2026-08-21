# frozen_string_literal: true

class AssignTargetFedipubActorsToFollows < ActiveRecord::Migration[8.1]
  def up
    Follow.find_each do |follow|
      follow.target_fedipub_actor = follow.target.fedipub_actor
      follow.save!
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
