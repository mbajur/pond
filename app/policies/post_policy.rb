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
      @scope
    end
  end
end
