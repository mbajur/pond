# frozen_string_literal: true

class CreateBoostsForPins < ActiveRecord::Migration[8.1]
  def up
    Pin.find_each do |pin|
      pin.pinable.announce!(actor: pin.collection.fedipub_actor) if pin.pinable.announcable?
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
