module Users
  class Unfollower
    def initialize(actor:, target:)
      @actor = actor
      @target = target
    end

    def call
      Fedipub::Following.find_by!(
        actor: @actor.fedipub_actor,
        target_actor: @target.fedipub_actor
      ).destroy!
    end
  end
end
