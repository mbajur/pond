class PinPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    !record.collection.private? || (user.present? && record.collection.user_id == user.id)
  end

  def create?
    user.present?
  end

  def create_text?
    user.present?
  end

  def update?
    user.present? && record.collection.user_id == user.id
  end

  def update_collection?
    user.present? && record.user_id == user.id
  end

  def destroy?
    user.present? && (record.user_id == user.id || record.collection.user_id == user.id)
  end

  def secondary_actions?
    user.present?
  end

  class Scope
    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      if @user.present?
        @scope.joins(:collection).where("collections.private = ? OR collections.user_id = ?", false, @user.id)
      else
        @scope.joins(:collection).where("collections.private = ?", false)
      end
    end
  end
end
