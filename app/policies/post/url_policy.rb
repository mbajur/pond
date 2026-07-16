class Post::UrlPolicy < PostPolicy
  def edit?
    update?
  end

  def update?
    false
  end

  def edit?
    user.present? && record.user_id == user.id
  end

  def update_url?
    edit?
  end
end
