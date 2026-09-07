class Post::TextPolicy < PostPolicy
  def new?
    create?
  end

  def create?
    user&.premium?
  end

  def edit?
    user.present? && record.fedipub_actor.id == user.fedipub_actor.id
  end

  def update_text?
    edit?
  end
end
