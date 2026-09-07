module Fedipub
  class Moderator < ApplicationRecord
    belongs_to :actor, class_name: "Fedipub::Actor"
    belongs_to :entity, polymorphic: true
  end
end
