class Post::UrlPolicy < PostPolicy
  def edit?
    update?
  end

  def update?
    false
  end

  def edit?
    user.present? && record.fedipub_actor.id == user.fedipub_actor.id
  end

  def update_url?
    edit?
  end
end
