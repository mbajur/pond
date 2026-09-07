# frozen_string_literal: true

class CreateLocalFedipubActors < ActiveRecord::Migration[8.1]
  def up
    User.find_each do |user|
      user.send(:create_fedipub_actor) unless user.fedipub_actor
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
