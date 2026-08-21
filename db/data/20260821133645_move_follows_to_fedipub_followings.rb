# frozen_string_literal: true

class MoveFollowsToFedipubFollowings < ActiveRecord::Migration[8.1]
  def up
    Follow.find_each do |follow|
      Fedipub::Following.create!(actor: follow.fedipub_actor, target_actor: follow.target_fedipub_actor)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
