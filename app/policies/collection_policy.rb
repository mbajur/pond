class CollectionPolicy < ApplicationPolicy
  def index?
    true
  end

  def inbox?
    true
  end

  def show?
    !record.private? || (user.present? && record.fedipub_moderators.include?(user.fedipub_actor))
  end

  def connect?
    user.present?
  end

  def create?
    user.present?
  end

  def update?
    user.present? && record.fedipub_moderators.include?(user.fedipub_actor) && !record.inbox?
  end

  def destroy?
    user.present? && record.fedipub_moderators.include?(user.fedipub_actor)
  end

  def follow?
    user.present? && record.user_id != user.id
  end

  def unfollow?
    follow?
  end

  class Scope
    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      if @user.present?
        @scope.where("collections.private = ? OR user_id = ?", false, @user.id)
      else
        @scope.where("collections.private = ?", false)
      end
    end
  end
end
