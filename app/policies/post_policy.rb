class PostPolicy < ApplicationPolicy
  def show?
    true
  end

  def new?
    user.present?
  end

  def connect?
    user.present?
  end

  def context_menu?
    user.present?
  end

  class Scope
    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      if @user.present?
        @scope
          .left_joins(pins: :collection)
          .where("collections.private = ? OR posts.user_id = ?", false, @user.id)
          .distinct
      else
        @scope
          .joins(pins: :collection)
          .where(collections: { private: false })
          .distinct
      end
    end
  end
end
