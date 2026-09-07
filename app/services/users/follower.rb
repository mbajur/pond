module Users
  class Follower
    def initialize(actor:, target:)
      @actor = actor
      @target = target
    end

    def call
      Fedipub::Following.find_or_create_by!(
        actor: @actor.fedipub_actor,
        target_actor: @target.fedipub_actor
      )
    end
  end
end
