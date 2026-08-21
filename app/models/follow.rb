class Follow < ApplicationRecord
  belongs_to :actor, class_name: "User", optional: true
  belongs_to :fedipub_actor, class_name: "Fedipub::Actor"
  belongs_to :target, polymorphic: true, optional: true
  belongs_to :target_fedipub_actor, class_name: "Fedipub::Actor"
end
